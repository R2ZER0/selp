package SquareStats::Manager;

use namespace::autoclean;
use Moose;
use Method::Signatures;
use Moose::Util::TypeConstraints;
use MooseX::Types::JSON qw/ JSON /;

# ABSTRACT: the Manager listens for events from the assaultcube server, and
#           notifies the loaded plugins of each event.
#
use ZMQx::Class;
use AnyEvent;
with 'MooseX::Role::Pluggable';

has 'endpoint' => (
        is => 'ro',
        isa => 'Str',
        required => 1,
);

has 'zmq_subscriber' => (
        is => 'ro',
        lazy => 1,
        builder => '_build_zmq_subscriber',
        isa => 'ZMQx::Class::Socket',
);

method _build_zmq_subscriber() {
        return ZMQx::Class->socket('SUB', connect => $self->endpoint);
}

method on_recv_json(JSON $json) {
        # Process the JSON into an event 
}

method run() {
        # Run the manager!
};


__PACKAGE__->meta->make_immutable;
1;
