use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::AC::Manager::Daemon {
    use Test::Class::Moose;
    use Test::MooseX::Daemonize;
    use File::Spec::Functions;
    use File::Temp qw(tempdir);
    use ZMQx::Class;
    use ZMQ::Constants qw(ZMQ_LAST_ENDPOINT);
    use Forks::Super;
    use AC::Manager::Daemon;
    
    method test_daemon(...) {
        $self->test_report->plan(2);
    
        # Use a temporary directory and files
        my $dir = tempdir( CLEANUP => 1 );
        
        my $config_file = catfile( $dir, "config.yaml" );
        my $pid_file    = catfile( $dir, "daemon.pid" );
        
        # Create a test socket
        # We have to fork to do this, due to a bug in libzmq which crashes the
        # program if you try to create a socket in the parent and then the child
        # (as we are fork()ing to test the daemon), so we put both the sockets
        # in child processes instead.
        my $child_pid = fork { timeout => 10, child_fh => 'out', sub => sub {
            my $pub = ZMQx::Class->socket('PUB', bind => "tcp://*:*");
            my $endpoint = $pub->getsockopt(ZMQ_LAST_ENDPOINT);
            $| = 1; print $endpoint;
            sleep(10);
        }};
        
        # The child creates the socket, and then pipes us the endpoint so we can
        # pass it to the daemon.
        my $child_stdout = $child_pid->{child_stdout};
        my $endpoint = <$child_stdout>;
            
        # Create test config file
        open CONFIG, '>', $config_file;
        print CONFIG "endpoint: $endpoint\n";
        
        ok( -e $config_file, "$config_file exists" );
        
        # Spawn the daemon!
        my $daemon = AC::Manager::Daemon->new(
            pidbase => $dir, configfile => $config_file
        );
        
        daemonize_ok( $daemon, 'daemon forked okay' );
        my $daemon_pid = $daemon->get_pid();
        
        $daemon->stop();
        kill 'TERM', $child_pid;
        waitpid $daemon->get_pid();
        waitpid $child_pid;
        
    }
    
}