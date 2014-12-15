use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::AC::Mananger::Plugin::Base {
        use Test::Class::Moose;
        use Try::Tiny;
        use AC::Manager::Plugin::Base;
        no strict 'refs';
        
        method tclass() {
            return 'AC::Manager::Plugin::Base';
        }

        method test_constructor($class: ...) {
                my $plugin_harness = class 
                with MooseX::Role::Pluggable
                {
                        # We use this anonymous class to load ::Plugin::Base,
                        # as plugins cannot be instantiated in isolation.
                }
        
                my $plugin_harness_obj = $plugin_harness->new_object({
                    plugins => [ "+" . $class->tclass() ],
                });
                
                isa_ok( $plugin_harness_obj->plugin_list->[0], $class->tclass());
        }

        method test_has_run_finish_methods($class: ...) {
                can_ok($class->tclass(), 'run', 'finish');
        }

        method test_has_event_methods($class: ...) {
                can_ok($class->tclass(), 'on_kill');
        }

}


