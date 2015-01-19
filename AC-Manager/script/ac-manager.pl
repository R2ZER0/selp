#!/usr/bin/env perl
use strict;
use warnings;
use lib '../lib';
use AC::Manager::Daemon;

my $daemon = AC::Manager::Daemon->new_with_options();
die 'Could not create daemon' unless $daemon;
 
my ($command) = @{$daemon->extra_argv};
defined $command || die "No command specified";
 
$daemon->start   if $command eq 'start';
$daemon->status  if $command eq 'status';
$daemon->restart if $command eq 'restart';
$daemon->stop    if $command eq 'stop';
 
warn($daemon->status_message);
exit($daemon->exit_code);
