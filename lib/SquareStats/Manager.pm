use SquareStats::Declare;

# ABSTRACT: the Manager listens for events from the assaultcube server, and
#           notifies the loaded plugins of each event.
class SquareStats::Manager
with MooseX::Role::Pluggable
{
        use AnyEvent;
        use ZMQx::Class;
        use MooseX::Types::JSON qw/ JSON /;
        use JSON::XS;
         
        
        has 'endpoint' => (
                is => 'ro',
                isa => 'Str',
                required => 1,
        );
        
        has 'zmq_subscriber' => (
                is => 'ro',
                lazy => 1,
                builder => '_build_zmq_subscriber',
                isa => 'ZMQx::Class::Socket',
        );
        
        method _build_zmq_subscriber() {
                return ZMQx::Class->socket('SUB', connect => $self->endpoint);
        }
        
        method emit_event(Str $event, HashRef $data) {
                my $method = "on_$event";
                foreach my $plugin (@{ $self->plugin_list }) {
                        if($plugin->can($method)) {
                                $plugin->$method($data);
                        }
                }
        }
        
        # TODO: Catch exception from invalid JSON
        method on_recv_json(JSON $json) {
                my $data = decode_json $json;
                $self->emit_event($data->{'type'}, $data);
        }
        
        # Initialise the subscriber socket
        method subscribe() {
                my $sub = $self->zmq_subscriber();

                # Subscribe to all messages, i.e. no filtering
                $sub->subscribe('');

                # Setup the on-receive-message event callback
                $sub->anyevent_watcher( sub {
                        while ( my $msg = $sub->receive ) {
                                $self->on_recv_json($msg->[0]);
                        }
                });
        }
        
        
}

1;
