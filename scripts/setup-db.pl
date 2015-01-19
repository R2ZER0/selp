#!/usr/bin/env perl
# This script installs the schema into the given database

# The dsn can be passed as the first argument, or from dsn.txt is used
my $dsn = $ARGV[1] || '';


BEGIN { $ENV{POSTGRES_HOME} = '/usr/pgsql-9.3'; }
use warnings;
use DBIx::Class;
use SquareStats::Schema;
use FindBin;
use File::Slurp qw/read_file/;
use lib "$FindBin::Bin/../SquareStats-App/lib";
$| = 1;

if(not $dsn) {
        # Read it from dsn file
        $dsn = read_file("$FindBin::Bin/dsn.txt") or die 'Could not load dsn.txt!';
}


# Install the schema to our database
print "Installing schema...";
SquareStats::Schema->load_classes({
    'SquareStats::Schema::Result' => [qw/Game Kill Users/],
});

my $schema = SquareStats::Schema->connect($dsn, '', '', {});
#$ENV{DBI_TRACE} = 1;
$schema->deploy({ auto_drop_tables => 1 });
#$ENV{DBI_TRACE} = 0;
print "Done\n";

