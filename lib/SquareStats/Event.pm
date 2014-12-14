use MooseX::Declare;
use Method::Signatures::Modifiers;

# ABSTRACT: A generic event role, to automatically de/serialise events
role SquareStats::Event {
        use MooseX::Types::JSON qw/ JSON /;
        use JSON::XS;
        use Module::Find;
        use List::Util;

        # Find all the available SquareStats::Event::* classes
        our @_found_classes = usesub SquareStats::Event;
        
        # Consumers must implement this method which returns the type
        # that it supports as a string.
        requires 'type';
        
        # Serialise this event as JSON
        method to_json() {
                # TODO
        }
        
        # Deserialise the json, inspect the type, create and return a
        # relevant SquareStats::Event::* object (class method).
        method from_json($class: JSON $json) {
                my $data = decode_json $json;
                my $type = $data->{'type'};
                undef $data->{'type'};

                if(any { $_ eq $type } @{$class->supported_events}) {
                        return $class->get_event_class()->new($data);
                } else {
                        return;
                }
        }
        
        # Return an arrayref of supported event types (class method).
        method supported_events($class:) {
                my @events = map { $_->type } @_found_classes;
                return \@events;
        }

        # Get the class assosciated with an event type
        method get_event_class($class: Str $event) {
                foreach my $evclass (@_found_classes) {
                        if($evclass->type eq $event) {
                                return $evclass;
                        }
                }
                return '';
        }
}
