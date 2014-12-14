use SquareStats::Declare;

class SquareStats::Manager::Daemon
extends SquareStats::Manager
with MooseX::Getopt
{
        with 'MooseX::Daemonize';

        after start() {
                return unless $self->is_daemon;
                $self->init();
        }

        before stop() {
                $self->deinit();
        }
}
