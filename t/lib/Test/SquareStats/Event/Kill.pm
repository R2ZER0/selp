package Test::SquareStats::Event::Kill;
use Test::Class::Moose;
use Try::Tiny;
use SquareStats::Event::Kill;
# ABSTRACT: Tests for the SquareStats::Event::Kill class

sub test_has_methods : Tests(2) {
        my $test = shift;

        my $class = 'SquareStats::Event::Kill';
        can_ok $class, 'new';
        can_ok $class, 'to_json';
}

sub test_standard_new : Test {
        my $test = shift;
        my $success = 1;

        try {
                my $event = SquareStats::Event::Kill->new(
                        killer  => 'K1ller',
                        victim  => 'Victim',
                        weapon  => 'subgun',
                        time    => 12345,
                        gib     => 0,
                        suicide => 1
                );
        } catch {
                $success = 0;
        };

        ok($success, 'create object normally');
};

1;
