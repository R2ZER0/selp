use SquareStats::Declare;

class SquareStats::Manager::Daemon
with MooseX::Getopt
{
        use SquareStats::Manager;
        use MooseX::Types::Path::Class;
        with 'MooseX::Daemonize';

        has '_manager' => (
                is => 'ro',
                isa => 'SquareStats::Manager',
                lazy => 1,
                builder => '_build_manager',
        );

        has 'configfile' => (
                is => 'ro',
                isa => 'Path::Class::File',
                default => sub { "conf/sample-manager.yaml" },
                description => 'path to configuration file',
        );
                

        method _build_manager() {
                return SquareStats::Manager->new_with_config(configfile => $self->configfile);
        }

        after start() {
                return unless $self->is_daemon;
                $self->run();
        }

        before stop() {
                $self->finish();
        }
}
