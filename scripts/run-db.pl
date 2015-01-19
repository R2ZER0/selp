#!/usr/bin/env perl
# Run the test database!

BEGIN { $ENV{POSTGRES_HOME} = '/usr/pgsql-9.3'; }
use strict;
use warnings;
use FindBin;
use File::Slurp qw/write_file/;
use Test::PostgreSQL;

print "Spawning postgres instance...";
my $pg = Test::PostgreSQL->new();
print "Done!\n";

my $dsn = $pg->dsn;
print "Got a DSN of: $dsn \n";

my $expected_dsn = "DBI:Pg:dbname=test;host=127.0.0.1;port=15432;user=postgres";
if($dsn ne $expected_dsn) {
        print "We got a different DSN than expected!\n";
        print "This one will need to replace the existing dsn in:\n";
        print "  SquareStats-App/lib/SquareStats/App/Model/SS.pm\n";
} else {
        print "This is as expected, everything should automatically use this db!\n";
}

print "(Writing dsn to dsn.txt)\n";
write_file("$FindBin::Bin/dsn.txt", $dsn);

print "\nUse Ctrl-C to kill the database.\n";

eval {
        local $SIG{'INT'} = sub { die ''; };
        sleep;
};

print "Removing dsn.txt\n";
unlink("$FindBin::Bin/dsn.txt");

print "Please wait for the database to exit...\n";