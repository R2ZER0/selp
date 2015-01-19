#!/usr/bin/env perl
# This script populates the database with a bunch of random data.

# The dsn can be passed as the first argument, or from dsn.txt is used
my $dsn = $ARGV[1] || '';


BEGIN { $ENV{POSTGRES_HOME} = '/usr/pgsql-9.3'; }
use warnings;
use DBIx::Class;
use SquareStats::Schema;
use Mock::Person::US;
use FindBin;
use File::Slurp qw/read_file/;
use lib "$FindBin::Bin/../SquareStats-App/lib";
$| = 1;

if(not $dsn) {
        # Read it from dsn file
        $dsn = read_file("$FindBin::Bin/dsn.txt") or die 'Could not load dsn.txt!';
}

my $schema = SquareStats::Schema->connect($dsn, '', '', {});

# Generate and insert some sample data
print "Generating sample data...";
my @games = ();

my $servername = 'testserv0';
my @maps = ('ac_desert', 'ac_desert2', 'ac_complex', 'TwinTowers', 'ac_douze',
            'ac_industrial', 'ac_arctic', 'ac_depot', 'ac_power', 'ac_sunset');
my @guns = ('shotgun', 'knife', 'grenade', 'subgun', 'carbine', 'sniper', 'pistol', 'assault');
my $mode = 'osok';

sub get_random_map { $maps[int(rand(10))]; }
sub get_random_gun { $guns[int(rand(8))]; }

my $game_id = 1;
my $kill_id = 1;

foreach (0..100) {
    my %game = (
        id => $game_id++,
        map => get_random_map(),
        server => $servername,
        mode => $mode,
        start_time => '2014-08-23 08:50:57.136817 Europe/London',
        end_time => '2014-08-23 08:59:57.136817 Europe/London',
    );
    
    my @kills = ();
    foreach (0..500) {
        my $killer = Mock::Person::US::last_name();
        my $victim = Mock::Person::US::last_name();
        my %kill = (
            id => $kill_id++,
            killer => $killer,
            victim => $victim,
            weapon => get_random_gun(),
            'time' => int(rand(15000)),
            gib    => (int(rand(50)) < 1) ? 1 : 0,
            suicide => ($killer eq $victim) ? 1 : 0,
            killer_x => int(rand(500)) - 250,
            killer_y => int(rand(500)) - 250,
            killer_z => int(rand(500)) - 250,
            victim_x => int(rand(500)) - 250,
            victim_y => int(rand(500)) - 250,
            victim_z => int(rand(500)) - 250,
        );
        push @kills, \%kill;
    }
    
    $game{kills} = \@kills;
    push @games, \%game;
}

print "Done\n";

print "Populating database...";
$schema->resultset('Game')->populate(\@games);
print "Done\n";

