package Test::SquareStats::Event;
use Test::Class::Moose;
use MooseX::Test::Role;
use SquareStats::Event;

my $role = 'SquareStats::Event';

sub test_has_class_methods : Tests(2) {
        can_ok $role, 'new_from_json';
        can_ok $role, 'supported_events';
}

sub test_has_consumer_methods : Tests(1) {
        my $consumer = consuming_class('SquareStats::Event',
                type => sub { "test" },
        );
        can_ok $consumer, 'to_json';       
}

sub test_requires : Tests(1) {
        requires_ok $role, 'type';
}

1;
