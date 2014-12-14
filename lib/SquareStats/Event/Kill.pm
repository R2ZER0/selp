use MooseX::Declare;
use Method::Signatures::Modifiers;

class SquareStats::Event::Kill with SquareStats::Event {
        use Moose::Util::TypeConstraints;
        
        subtype 'Natural',
            as 'Int',
            where { $_ > 0 };
        
        enum 'Weapon',
            [qw{knife pistol carbine shotgun subgun sniper assault grenade}];
        
        method type() { 'kill' }
        has 'killer'  => (is => 'ro', isa => 'Str', required => 1);
        has 'victim'  => (is => 'ro', isa => 'Str', required => 1);
        has 'weapon'  => (is => 'ro', isa => 'Weapon', required => 1);
        has 'time'    => (is => 'ro', isa => 'Natural', required => 1);
        has 'gib'     => (is => 'ro', isa => 'Bool', required => 1);
        has 'suicide' => (is => 'ro', isa => 'Bool', required => 1);
}

1;
