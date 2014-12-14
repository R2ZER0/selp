#!/usr/bin/env perl
# Load all the test classes in 'lib' and run them
use Test::Class::Moose::Load 't/lib';
use Test::Class::Moose::Runner;
Test::Class::Moose::Runner->new->runtests;
