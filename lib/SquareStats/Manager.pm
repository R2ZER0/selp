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
        
        
        method run() {
                # Run the manager!
        };
        
        
}

1;
