package SquareStats;
use warnings;
use strict;
use Moops;

# ABSTRACT: the Manager listens for events from the assaultcube server, and
#           notifies the loaded plugins of each event.

class Manager with MooseX::Role::Pluggable {
        use ZMQx::Class;
        use AnyEvent;

        has 'endpoint' => (
                is => 'ro',
                isa => 'Str',
                required => 1,
        );

        has 'zmq_subscriber' => (
                is => 'lazy',
                isa => 'ZMQx::Class::Socket',
        );

        method _build_zmq_subscriber () {
                return ZMQx::Class->socket('SUB', connect => $self->endpoint);
        }

        method on_recv_json () {
               # Process the JSON into an event 
        }

        method run () {
                # Run the manager!
        }
};

1;
