use MooseX::Declare;
use Method::Signatures::Modifiers;

role SquareStats::Event {
        use MooseX::Types::JSON qw/ JSON /;
        use JSON::XS;
        
        # Consumers must implement this method which returns the type
        # that it supports.
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
        
        # Return a list of supported event types (class method).
        method supported_events($class:) {
                # TODO
        }
}
