package SquareStats;
use Moops;

class Manager {
        use AnyEvent;

        has 'endpoint' => (
                is => 'ro',
                isa => 'Str',
                required => 1
        );

        method run () {
                # Run the manager!
        }

};
