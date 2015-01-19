#!/usr/bin/env perl

# This script runs the Collector server

use strict;
use warnings;

use AnyEvent;
use FindBin;
use File::Slurp qw/read_file/;
use SquareStats::Collector;

my $dsn = $ARGV[1] || read_file("$FindBin::Bin/dsn.txt") || die 'Could not load dsn.txt!';

my $collector = SquareStats::Collector->new({
        endpoint => 'tcp://*:28766/',
        dsn => $dsn,
});

my $w; $w = AnyEvent->signal(signal => 'INT', cb => sub {
        $collector->finish();
        undef $w;
});

print "Starting collector, use Ctrl-C or SIGINT to stop.\n";

$collector->run();