use MooseX::Declare;
use Method::Signatures::Modifiers;

# ABSTRACT: the Manager listens for events from the assaultcube server, and
#           notifies the loaded plugins of each event.
class AC::Manager
with MooseX::Role::Pluggable
with MooseX::SimpleConfig
{
        use AnyEvent;
        use ZMQx::Class;
        use MooseX::Types::JSON qw/ JSON /;
        use JSON::XS;
        use TryCatch;

        # Method used to start the manager
        # Register events and start the mainloop
        method run() {
                $self->plugin_run_method('run');
                $self->_subscribe(); # subscribe to events from the AC server

                $self->_exit_condvar->recv; # run the event loop

                $self->_on_finish;
        }
        
        # Method used to stop the manager
        method finish() {
            $self->_exit_condvar->send;
        }
        
        # Required parameter: ZMQ endpoint to connect to
        has 'endpoint' => (
                is => 'ro',
                isa => 'Str',
                required => 1,
        );
        
        has '_exit_condvar' => (
                is => 'ro',
                isa => 'AnyEvent::CondVar',
                default => sub { AnyEvent->condvar },
        );
        
        has '_subscriber' => (
                is => 'rw',
                isa => 'ZMQx::Class::Socket',
        );
        
        # Initialise the subscriber socket
        method _subscribe() {
                my $sub = ZMQx::Class->socket('SUB', connect => $self->endpoint);

                # Subscribe to all messages, i.e. no filtering
                $sub->subscribe('');

                # Setup the on-receive-message event callback
                $sub->anyevent_watcher( sub {
                        while ( my $msg = $sub->receive ) {
                                try { $self->on_recv_json($msg->[0]); }
                                catch {
                                        # Received invalid JSON, TODO: Logging
                                }
                        }
                });
                
                $self->_subscriber( $sub );
        }
        
        method _on_recv_json(JSON $json) {
                my $data = decode_json $json;
                $self->emit_event($data->{'type'}, $data);
        }
        
        method _emit_event(Str $event, HashRef $data) {
                my $method = "on_$event";
                foreach my $plugin (@{ $self->plugin_list }) {
                        if($plugin->can($method)) {
                                $plugin->$method($data);
                        }
                }
        }
        
        # Notify the plugins that we are stopping
        method _on_finish() {
                $self->_subscriber->close();
                $self->plugin_run_method('finish');
                # DBIx::Class automagically cleans up the sockets etc for us
        }       
}

1;
