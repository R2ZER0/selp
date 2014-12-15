use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::AC::Manager::Daemon {
    use Test::Class::Moose;
    use Test::MooseX::Daemonize;
    use File::Spec::Functions;
    use File::Temp qw(tempdir);
    use ZMQx::Class;
    use ZMQ::Constants qw(ZMQ_LAST_ENDPOINT);
    use AC::Manager::Daemon;
    
    method test_daemon(...) {
        $self->test_report->plan(4);
    
        # Use a temporary directory and files
        my $dir = tempdir( CLEANUP => 1 );
        
        my $file = catfile( $dir, "config.yaml" );
        my $pidf = catfile( $dir, "daemon.pid" );
        
        # Create a test socket
        my $pub = ZMQx::Class->socket('PUB', bind => "tcp://*:*");
        my $endpoint = $pub->getsockopt(ZMQ_LAST_ENDPOINT);
        
        # Create test config file
        open FILE, '>', $file;
        print FILE "endpoint: $endpoint";
        
        ok( -e $file, "$file exists" );
        
        # Spawn the daemon!
        my $daemon = AC::Manager::Daemon->new( pidbase => $dir, configfile => $file );
        
        daemonize_ok( $daemon, 'child forked okay' );
        ok( -e $pidf, "$pidf exists" );
        
    }
    
}