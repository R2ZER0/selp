use MooseX::Declare;
use Method::Signatures::Modifiers;

class SquareStats::Collector::ACManagerPlugin
extends AC::Manager::Plugin::Base
{
    use MooseX::Types::Set::Object;
    use JSON::XS;
    use DateTime;
    use DateTime::Format::Pg;

    has 'endpoint' => (
        is => 'ro',
        isa => 'Str',
        required => 1,
        documentaton => 'The ZMQ endpoint of the Collector',
    );
    
    # This is the name given as "server": "<name>" in the game data.
    has 'server_name' => (
        is => 'ro',
        isa => 'Str',
        required => 1,
        documentaton => 'The name of this server',
    );
    
    # Initialise our plugin
    override run() {
        $self->_socket_watcher();
    }
    
    # Clean up
    override finish() {
        # Say we are in the middle of recording a game: Should we send the game
        # data, even if it's incomplete?
        # I think not, as it could be incomplete, and might not represent the
        # true end-of-game, making it inconsistent with reality.
        $self->_clear_socket_watcher();
        $self->_socket()->close();
    }
    
    # We are starting a new game, replace the game info
    override on_game_start($game) {
        $game->{'server'} = $self->server_name();
        $game->{'start_time'} = DateTime::Format::Pg->format_timestamp_with_time_zone(
            DateTime->now(timezone=>'Europe/London')
        );
        $self->_game($game);
    }
    
    override on_game_end() {
        my $game = $self->_game();
        $game->{'end_time'} = DateTime::Format::Pg->format_timestamp_with_time_zone(
            DateTime->now(timezone=>'Europe/London')
        );
        $game->{'kills'} = $self->_kills();
        $self->_socket()->send(encode_json $game);
    }
    
    override on_kill($kill) {
        $self->_add_kill($kill);
    }

    # Current game information
    has '_game' => (
        is => 'rw',
        isa => 'HashRef',
        default => sub { {} },
    );
    
    # The list of kills so far this game
    has '_kills' => (
        traits => ['Array'],
        is => 'rw',
        isa => 'ArrayRef[HashRef]',
        default => sub { [] },
        handles => {
            _add_kill => 'push',
        },
    );
    
    # ZMQ REQ socket connecting to the Collector
    has '_socket' => (
        is => 'ro',
        isa => 'ZMQx::Socket',
        lazy => 1,
        builder => '_build_socket',
    );
    
    method _build_socket() {
        return ZMQx::Class->socket('REQ', connect => $self->endpoint);
    }
    
    # Watcher to watch the socket for responses
    has '_socket_watcher' => (
        is => 'ro',
        lazy => 1,
        builder => '_build_socket_watcher',
    );
    
    method _build_socket_watcher() {
        return $self->_socket()->anyevent_watcher( sub {
            my $got = $self->_socket()->receive();
            if($got) {
                $self->_on_response($got->[0]);
            }
        });
    }
    
    method _on_response($msg) {
        my $data = decode_json $msg;
        if($data->{'status'} ne 'ok') {
            # TODO: logging?
        }
    }
}