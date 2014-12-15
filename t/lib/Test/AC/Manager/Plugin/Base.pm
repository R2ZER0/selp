use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::AC::Mananger::Plugin::Base {
        use Test::Class::Moose;
        use TryCatch;
        use AC::Manager::Plugin::Base;

        my $class = 'AC::Manager::Plugin::Base';

        method test_constructor() {
                my $success = 1;

                try {
                        my $obj = AC::Manager::Plugin::Base->new();
                } catch {
                        $success = 0;
                }
                ok($success, 'construction succeeds');
        }
        
        method test_class() {
            my $obj = AC::Manager::Plugin::Base->new();
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


