use MooseX::Declare;
use Method::Signatures::Modifiers;

class AC::Manager::Daemon
with MooseX::Getopt
{
        use AC::Manager;
        use MooseX::Types::Path::Class;
        with 'MooseX::Daemonize';

        has '_manager' => (
                is => 'rw',
                isa => 'AC::Manager',
                lazy => 1,
                builder => '_build_manager',
        );

        has 'configfile' => (
                is => 'ro',
                isa => 'Path::Class::File',
                required => 1,
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
