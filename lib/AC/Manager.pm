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
        use Log::Any;
        
        our $log = Log::Any->get_logger(category => __PACKAGE__);

        # Method used to start the manager
        # Register events and start the mainloop
        method run() {
                $log->debug('starting to run, calling to plugins');
                $self->plugin_run_method('run');
                
                $self->_subscribe(); # subscribe to events from the AC server

                $log->debug('entering event loop');
                $self->_exit_condvar->recv(); # run the event loop

                $self->_on_finish();
        }
        
        # Method used to stop the manager
        method finish() {
            $log->debug('we have been asked to finish');
            $self->_exit_condvar->send();
        }
        
        # Required parameter: ZMQ endpoint to connect to
        has 'endpoint' => (
                is => 'ro',
                isa => 'Str',
                required => 1,
        );
        
        has '_exit_condvar' => (
                is => 'rw',
                isa => 'AnyEvent::CondVar',
                default => sub { AnyEvent->condvar },
        );
        
        has '_subscriber' => (
                is => 'rw',
                isa => 'ZMQx::Class::Socket',
        );
        
        # A watcher to watch the subscriber for incoming messages
        has '_watcher' => (
                is => 'rw',
                clearer => '_clear_watcher',
        );
        
        # Initialise the subscriber socket
        method _subscribe() {
                $log->debugf('subscribing to %s', $self->endpoint);
                my $sub = ZMQx::Class->socket('SUB', connect => $self->endpoint);

                # Subscribe to all messages, i.e. no filtering
                $sub->subscribe('');

                $log->debug('successfully subscribed, starting watcher');
                # Setup the on-receive-message event callback
                my $watcher = $sub->anyevent_watcher( sub {
                        while ( my $msg = $sub->receive ) {
                                $self->_on_recv_json($msg->[0]);
                        }
                });
                
                $self->_subscriber( $sub );
                $self->_watcher( $watcher );
        }
        
        method _on_recv_json(Str $json) {
                my $data = decode_json $json;
                $log->debugf('receieved json event of type %s', $data->{'type'});
                $self->_emit_event($data->{'type'}, $data);
        }
        
        method _emit_event(Str $event, HashRef $data) {
                $log->debug("emitting event of type $event");
                my $method = "on_$event";
                foreach my $plugin (@{ $self->plugin_list }) {
                        if($plugin->can($method)) {
                                $plugin->$method($data);
                        }
                }
        }
        
        # Notify the plugins that we are stopping
        method _on_finish() {
                $log->debug('finishing, closing subscriber');
                $self->_subscriber->close();
                $self->_clear_watcher();
                $log->debug('giving plugins the finish signal');
                $self->plugin_run_method('finish');
                # ZMQx::Class automagically cleans up the sockets etc for us
        }       
}

1;
