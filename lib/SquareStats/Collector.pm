use MooseX::Declare;
use Method::Signatures::Modifiers;

# ABSTRACT: Collects and stores game statistics from AssaultCube servers
class SquareStats::Collector
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
        
        # Run the event loop - this works by blocking, waiting for something to
        # send data to this condvar. We send in finish() to exit the loop again.
        $self->_finish_condvar->recv;
    }
    
    method finish() {
        $self->_finish_condvar->send;
    }
    
    
    # Private attributes
    has '_socket_watcher' => (
        is => 'ro',
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
        isa => 'SquareStats::Schema',
        lazy => 1,
        builder => '_build_schema',
    );
    
    has '_finish_condvar' => (
        is => 'ro',
        isa => 'AnyEvent::CondVar',
        lazy => 1,
        default => sub { AnyEvent->condvar },
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
        $self->_socket->send(encode_json {
            status => 'ok',
        });
    }
    
    method _store_game($game) {
        # I love whoever made DBIx::Class
        $self->_schema()->populate('Game', [$game]);
    }
    
    

}
1;
