use MooseX::Declare;
use Method::Signatures::Modifiers;

# ABSTRACT: Collects and stores game statistics from AssaultCube servers
class SquareStats::Collector
with MooseX::SimpleConfig
{
    use SquareStats::Schema;
    use Log::Any;
    use ZMQx::Class;
    use JSON::XS;
    
    our $log = Log::Any->get_logger(category => __PACKAGE__);
    
    # Public parameters, which can be loaded from config
    has 'endpoint' => (
        is => 'ro',
        isa => 'Str',
        default => sub { 'tcp://*.24042' },
        documentation => 'The ZMQ endpoint to bind to',
    );
    
    has 'dsn' => (
        is => 'ro',
        isa => 'Str',
        required => 1,
        documentation => 'The database connection string',
    );
    
    # Public methods
    method run() {
        # construct our socket watcher, which in turn constructs the ZMQ socket,
        # and binds it to the given endpoint.
        $self->_socket_watcher(); 
        
        # construct our schema (database access object), which in turn connects
        # to the database using the given dsn.
        $self->_schema();
    }
    
    method finish() {
        # TODO 
    }
    
    
    # Private attributes
    has '_socket_watcher' => (
        is => 'ro',
        isa => 'AnyEvent::IO',
        lazy => 1,
        builder => '_build_socket_watcher',
        clearer => '_clear_socket_watcher',
    );
    
    has '_socket' => (
        is => 'ro',
        isa => 'ZMQx::Class::Socket',
        lazy => 1,
        builder => '_build_socket',
    );
    
    has '_schema' => (
        is => 'ro',
        isa => 'ZMQx::Class::Socket',
        lazy => 1,
        builder => '_build_schema',
    );
    
    method _build_socket_watcher() {
        return $self->_socket()->anyevent_watcher( sub {
            $self->_on_message(
                $self->_socket()->receive()->[0]
            );
        });
    }
    
    method _build_socket() {
        return ZMQx::Class->socket('REP', bind => $self->endpoint());
    }
    
    method _build_schema() {
        return SquareStats::Schema->connect($self->dsn, '', '', {});
    }
    
    # Private methods
    method _on_message($msg) {
        my $game = decode_json $msg;
        $self->_store_game($game);
    }
    
    method _store_game($game) {
        # I love whoever made DBIx::Class
        $self->_schema()->populate('Game', $game);
    }
    
    

}
1;
