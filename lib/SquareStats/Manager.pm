use SquareStats::Declare;

# ABSTRACT: the Manager listens for events from the assaultcube server, and
#           notifies the loaded plugins of each event.
class SquareStats::Manager
with MooseX::Role::Pluggable
with MooseX::SimpleConfig
{
        use AnyEvent;
        use ZMQx::Class;
        use MooseX::Types::JSON qw/ JSON /;
        use JSON::XS;
        use TryCatch;

        # Register events and start the mainloop
        method run() {
                $self->plugin_run_method('run');
                $self->subscribe(); # subscribe to events from the AC server

                $self->_exit_condvar->recv; # run the event loop

                $self->finish;
        }

        # Notify the plugins that we are stopping
        method finish() {
                $self->plugin_run_method('finish');
                # DBIx::Class automagically cleans up the sockets etc for us
        }
         
        
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
        
        method _emit_event(Str $event, HashRef $data) {
                my $method = "on_$event";
                foreach my $plugin (@{ $self->plugin_list }) {
                        if($plugin->can($method)) {
                                $plugin->$method($data);
                        }
                }
        }
        
        method _on_recv_json(JSON $json) {
                my $data = decode_json $json;
                $self->emit_event($data->{'type'}, $data);
        }
        
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
        }
        
        
}

1;
