use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::SquareStats::Mananger::Plugin::Base {
        use Test::Class::Moose;
        use TryCatch;
        use SquareStats::Manager::Plugin::Base;

        my $class = 'SquareStats::Manager::Plugin::Base';

        method test_constructor() {
                my $success = 1;
                my $obj;

                try {
                        $obj = SquareStats::Manager::Plugin::Base->new();
                } catch {
                        $success = 0;
                }
                ok($success, 'construction succeeds');
                isa_ok $obj, $class;
        }

        method test_has_run_finish_methods() {
                can_ok $class, 'run';
                can_ok $class, 'finish';
        }

        method test_has_event_methods() {
                can_ok $class, 'on_kill';
        }

}


