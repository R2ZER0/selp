use MooseX::Declare;
use Method::Signatures::Modifiers;

class AC::Manager::Daemon
with MooseX::Getopt
{
        use AC::Manager;
        use MooseX::Types::Path::Class;
        with 'MooseX::Daemonize';

        has '_manager' => (
                is => 'ro',
                isa => 'AC::Manager',
                lazy => 1,
                builder => '_build_manager',
        );

        has 'configfile' => (
                is => 'ro',
                isa => 'Path::Class::File',
                required => 1,
                description => 'path to configuration file',
        );
                

        method _build_manager() {
                return AC::Manager->new_with_config(configfile => $self->configfile);
        }

        after start() {
                return unless $self->is_daemon;
                $self->run();
        }

        before stop() {
                $self->finish();
        }
}
