#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use AnyEvent;
use JSON::XS;
use ZMQx::Class;
use Test::PostgreSQL;
use SquareStats::Schema;
use SquareStats::Collector;

print STDERR "Using SquareStats::Schema VERSION $SquareStats::Schema::VERSION\n";

# Create a temporary PostgreSQL server
my $pgsql = Test::PostgreSQL->new()
    or plan skip_all => $Test::PostgreSQL::errstr;
    
# Create a ZMQ socket
my $zmq_endpoint = 'tcp://0.0.0.0:24042/';
my $req = ZMQx::Class->socket('REQ', connect => $zmq_endpoint)
    or plan skip_all => 'Could not create socket';

plan tests => 4;

my $schema = SquareStats::Schema->connect($pgsql->dsn, '', '', {});
$schema->deploy(); # Install the schema into our blank test DB

my $obj = SquareStats::Collector->new(
    dsn => $pgsql->dsn,
    endpoint => $zmq_endpoint,
);

## Does the constructor work?
isa_ok($obj, 'SquareStats::Collector');


## Now we want to test the actual functionality - putting games into
## the database.

my $game = encode_json ({
        map         => 'ac_somemap',
        mode        => 'osok',
        start_time   => '2014-08-23 08:50:57.136817 Europe/London',
        end_time     => '2014-08-23 08:55:56.142817 Europe/London',
        server      => 'uk1',
        kills => [
            {
                killer => 'k1LL3r', victim => 'VicTim',
                weapon => 'subgun', time => 123546,
                gib => 0, suicide => 0,
                killer_x => 123, killer_y => 321, killer_z => 10,
                victim_x => 531, victim_y => 949, victim_z => 8,
            }
        ],
});

# Make sure we don't wait more than 10 seconds
my $waiting = 1;
my $w; $w = AnyEvent->timer(after => 10, cb => sub {
    $waiting = 0;
    undef $w;
});

# Create a timer which watches to see if things have been added to the database
my $t; $t = AnyEvent->timer(after => 0.2, interval => 0.5, cb => sub {
    my $count = $schema->resultset('Game')->count();
    if(($count > 0) or (not $waiting)) {
        ok($count == 1, 'inserted game data');
        ok($schema->resultset('Kill')->count() == 1, 'inserted kill data');
        $obj->finish();
        undef $t;
    }
    
});

# Send the data once the Collector has started
my $s; $s = AnyEvent->timer(after => 0.1, cb => sub {
    $req->send([$game]);
    undef $s;
});

# Make sure we receive the data back as well
my $d; $d = $req->anyevent_watcher( sub {
    my $got = $req->receive();
    if($got) {
        my $msg = decode_json ($got->[0]);
        ok($msg->{'status'} eq 'ok');
        undef $d;
    } elsif(not $waiting) {
        undef $d;
    }
});

# Run the collector
$obj->run();


done_testing();