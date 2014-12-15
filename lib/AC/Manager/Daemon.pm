use MooseX::Declare;
use Method::Signatures::Modifiers;

class AC::Manager::Daemon
with MooseX::Getopt
{
        use AC::Manager;
        with 'MooseX::Daemonize';

        has 'configfile' => (
                is => 'ro',
                isa => 'Str',
                default => '/etc/ac-manager.yaml',
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
                
                $self->_manager()->run();
        }

        before stop() {
                $self->_manager()->finish();
        }
}
