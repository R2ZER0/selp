use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::AC::Manager_Plugin
with MooseX::Role::Pluggable::Plugin
{
    has 'run_called' => (is => 'rw', isa => 'Bool', default => sub { 0 });
    has 'finish_called' => (is => 'rw', isa => 'Bool', default => sub { 0 });
    has 'on_kill_called' => (is => 'rw', isa => 'Bool', default => sub { 0 });
    
    method run() { $self->run_called(1); }
    method finish() { $self->finish_called(1); }
    method on_kill() { $self->on_kill_called(1); }
}

class Test::AC::Manager {
    use Test::Class::Moose;
    use ZMQx::Class;
    use ZMQ::Constants qw/ZMQ_LAST_ENDPOINT/;
    use AC::Manager;
    use AnyEvent;
    
    method test_manager($class: ...) {
        # First create a test ZMQ publisher, so we can send events
        my $pub = ZMQx::Class->socket('PUB', bind => 'tcp://*:*');
        my $endpoint = $pub->getsockopt(ZMQ_LAST_ENDPOINT);
    
        # Test that it is possible to create a Manager object
        my $man = AC::Manager->new(
            endpoint => $endpoint,
            plugins => ['+Test::AC::Manager_Plugin'],
        );
        ok($man, 'constructed manager');
    
        # Test that it successfully loads our plugin
        my $plugin = $man->plugin_list->[0];
        isa_ok($plugin, 'Test::AC::Manager_Plugin');
        
        # Test that it calls run/finish on our plugin
        my $w; $w = AnyEvent->idle(cb => sub {
            $man->finish();
            undef $w;
        });
        $man->run();
        
        ok($plugin->run_called, 'run called');
        ok($plugin->finish_called, 'finish called');        
        
        # Test that it propagates events to our plugin
        my $kill_event_json = q{{
            "type": "kill",
            "killer": "killer",
            "victim": "victim",
            "weapon": "shotgun",
            "time": 12345,
            "gib": false,
            "suicide": false
        }};
        
        # Wait up to 10 seconds for our event to be fired
        my $waiting = 1;
        
        my $w2; $w2 = AnyEvent->timer(after => 10, cb => sub {
            $waiting = 0;
            undef $w2;
        });
        
        my $w3; $w3 = AnyEvent->idle(cb => sub {
            if($plugin->on_kill_called or (not $waiting)) {
                ok($plugin->on_event_called, 'on_kill event passed to plugin');
                undef $w3;
            }
        });
        
        $pub->send($kill_event_json);
        
    }
}