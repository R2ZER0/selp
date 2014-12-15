use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::AC::Mananger::Plugin::Base {
        use Test::Class::Moose;
        use Try::Tiny;
        use AC::Manager::Plugin::Base;

        my $class = 'AC::Manager::Plugin::Base';

        method test_constructor(...) {
                my $plugin_harness = class 
                with MooseX::Role::Pluggable
                {
                        # We use this anonymous class to load ::Plugin::Base,
                        # as plugins cannot be instantiated in isolation.
                }
        
                my $plugin_harness_obj = $plugin_harness->new_object({
                    plugins => [ '+AC::Manager::Plugin::Base' ],
                });
                
                isa_ok( $plugin_harness_obj->plugin_list->[0], $class );
        }

        method test_has_run_finish_methods(...) {
                can_ok $class, 'run';
                can_ok $class, 'finish';
        }

        method test_has_event_methods(...) {
                can_ok $class, 'on_kill';
        }

}


