use MooseX::Declare;
use Method::Signatures::Modifiers;

class AC::Manager::Daemon
with MooseX::Getopt
{
        use Log::Any::Adapter;
        use AC::Manager;
        with 'MooseX::Daemonize';

        has 'configfile' => (
                is => 'ro',
                isa => 'Str',
                default => '/etc/ac-manager.yaml',
        );
        
        has 'logfile' => (
                is => 'ro',
                isa => 'Str',
                default => '/var/log/ac-manager.log',
        );
        
        has '_manager' => (
                is => 'ro',
                isa => 'AC::Manager',
                lazy => 1,
                builder => '_build_manager',
        );
        
        method _build_manager() {
                return AC::Manager->new_with_config(
                        configfile => $self->configfile
                );
        }

        after start() {
                return unless $self->is_daemon;
                
                Log::Any::Adapter->set('File', $self->logfile());
                $self->_manager()->run();
        }

        before stop() {
                return unless $self->is_daemon;
                $self->_manager()->finish();
        }
}
