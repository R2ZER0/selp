package SquareStats::Event;
use Moose::Role;
use Method::Signatures;
use MooseX::Types::JSON qw/ JSON /;
use JSON::XS;

has 'type' => (
        is => 'ro',
        isa => 'Str',
        required => 1
);

# Serialise this event as JSON
method to_json() {
        # TODO
}

# Deserialise the json, inspect the type, create and return a relevant
# SquareStats::Event::* object.
func from_json(JSON $json) {
        # TODO
}

# Return a list of supported event types
func supported_events() {
        # TODO
}

1;
