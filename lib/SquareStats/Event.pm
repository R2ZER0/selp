use MooseX::Declare;
use Method::Signatures::Modifiers;

role SquareStats::Event {
        use MooseX::Types::JSON qw/ JSON /;
        use JSON::XS;
        use Module::Find;

        # Find all the available SquareStats::Event::* modules
        our @_found_modules = usesub SquareStats::Event;
        
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
                # TODO
        }
        
        # Return an arrayref of supported event types (class method).
        method supported_events($class:) {
                my @events = map { $_->type } @_found_modules;
                return \@events;
        }
}
