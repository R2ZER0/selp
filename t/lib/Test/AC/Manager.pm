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
    
    method test_manager($class: ...) {
        # First create a test ZMQ publisher, so we can send events
        my $pub = ZMQx::Class->socket('PUB', bind => 'tcp://*:*');
        my $port = $pub->getsockopt(ZMQ_LAST_ENDPOINT);
    
        # Test that it is possible to create a Manager object
        my $man = AC::Manager->new(
            endpoint => "tcp://localhost:$port",
            plugins => ['+Test::AC::Manager_Plugin'],
        );
        ok($man, 'constructed manager');
    
        # Test that it successfully loads our plugin
        isa_ok($man->plugin_list->[0], 'Test::AC::Manager_Plugin');
        
        # Test that it calls run/finish on our plugin
        
        
        # Test that it propagates events to our plugin
    }
}