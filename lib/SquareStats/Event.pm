package SquareStats::Event;
use Moose::Role;
use Method::Signatures;
use MooseX::Types::JSON qw/ JSON /;
use JSON::XS;

method to_json() {
        # TODO: Serialise as JSON
}

func from_json(JSON $json) {
        # TODO: Search namespace for correct object, and create it.
}


1;
