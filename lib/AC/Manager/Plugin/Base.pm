use MooseX::Declare;
use Method::Signatures::Modifiers;

# ABSTRACT: A base Manager::Plugin that does nothing
class AC::Manager::Plugin::Base
with MooseX::Role::Pluggable::Plugin
{
        method run() {
                # Run!
        }

        method finish() {
                # It's over!
        }

        method on_kill(HashRef $event) {
                # Someone has been killed!
        }
        
        method on_game_start(HashRef $event) {
                # The game has begun
        }
        
        method on_game_end(HashRef $event) {
                # The game has finished
        }
}
