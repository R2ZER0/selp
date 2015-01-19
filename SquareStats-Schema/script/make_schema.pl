#!/usr/bin/env perl
use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;
use File::Slurp qw/ read_file /;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use Test::PostgreSQL;

my $dsn = '';
my $from = 'share/sql/schema.sql';
my $debug = 0;
my $help = 0;

GetOptions(
        "dsn=s" => \$dsn,
        "from=s" => \$from,
        "debug!" => \$debug,
        "help" => \$help,
);

if($help) {
        pod2usage(1);
        exit();
}

my $pgsql;
if(not $dsn) {
        $pgsql = Test::PostgreSQL->new();
        $dsn = $pgsql->dsn;
}

if($from) {
        my $sql = read_file($from);
        print $sql;
        DBI->connect($dsn,'','',{})->do( $sql, {} );
}

make_schema_at(
        'SquareStats::Schema',
        {
                debug => $debug,
                dump_directory => './lib',
                skip_load_external => 1,
        },
        [$dsn, "", "", {}],
);

__END__

=head1 NAME

make_schema.pl - Automatically generate SquareStats::Schema[::*] modules from a PostgreSQL database.

=head1 SYNOPSIS

scripts/make_schema.pl [options]

  Options:
    --help              This help message
    --host <host>       Hostname or IP of the database server
    --database <dbname> Name of the database to use
    --username <user>   Username for accessing the database
    --password <passwd> The user's password
    --debug             Enable debugging output

=head1 DESCRIPTION

This program will generate the SquareStats::Schema and
SquareStats::Schema::Result::* modules from the given database. The database
must have been previously initialised. The modules will be output into the
'lib' directory, based on the current working directory.

By default this creates a temporary database, and loads a schema from
share/sql/schema.sql

=cut

