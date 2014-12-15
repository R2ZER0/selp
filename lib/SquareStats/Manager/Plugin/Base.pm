use MooseX::Declare;
use Method::Signatures::Modifiers;

# ABSTRACT: A base Manager::Plugin that does nothing
class SquareStats::Manager::Plugin::Base
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
}
