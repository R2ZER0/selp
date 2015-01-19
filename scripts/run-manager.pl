#!/usr/bin/env perl

# Run the AC::Manager using the SquareStats::Collector::ACManagerPlugin

use strict;
use warnings;

use FindBin;
use AnyEvent;
use Log::Any::Adapter ('Stdout'); # log to stdout
use AC::Manager;

my $manager = AC::Manager->new({
        endpoint => "tcp://localhost:28765/",   # endpoint of the AC server
        plugins => [
                {'+SquareStats::Collector::ACManagerPlugin' => {
                        endpoint => "tcp://localhost:28766/", # endpoint of the Collector server
                        server_name => "test1",
                }}
        ],
});

my $sigint_watcher;
$sigint_watcher = AnyEvent->signal(signal => 'INT', cb => sub {
        $manager->finish();
        undef $sigint_watcher; # only catch it once
});

print "Starting manager, use Ctrl-C or SIGINT to stop.\n";

$manager->run();