use MooseX::Declare;
use Method::Signatures::Modifiers;

class AC::Manager::Daemon
with MooseX::Getopt
{
        use AC::Manager;
        with 'MooseX::Daemonize';

        has '_manager' => (
                is => 'rw',
                isa => 'AC::Manager',
        );

        has 'configfile' => (
                is => 'ro',
                isa => 'Str',
                default => '/etc/ac-manager.yaml',
        );

        after start() {
                return unless $self->is_daemon;
                
                $self->_manager(AC::Manager->new_with_config(
                    configfile => $self->configfile
                ));
                $self->_manager->run();
        }

        before stop() {
                $self->_manager->finish();
        }
}
