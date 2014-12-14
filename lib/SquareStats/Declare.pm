use MooseX::Declare;

# ABSTRACT: Use MooseX::Declare with Method::Signatures::Modifiers.
# A convenience class to hide boilerplate code.
class SquareStats::Declare extends MooseX::Declare
{
        use Method::Signatures::Modifiers;
}

1;
