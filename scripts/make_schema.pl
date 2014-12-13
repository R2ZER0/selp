#!/usr/bin/env perl
use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;

my $host = '';
my $user = '';
my $pass = '';
my $db = 'squarestats';
my $debug = '';
my $help = 0;

GetOptions(
        "host|h=s" => \$host,
        "username|u=s" => \$user,
        "password|p=s" => \$pass,
        "database|d=s" => \$db,
        "debug!" => \$debug,
        "help" => \$help,
);

if($help) {
        pod2usage(1);
        exit();
}

my $dsn = 'dbi:Pg:';
$dsn .= "dbname=$db;" if $db;
$dsn .= "host=$host;" if $host;

make_schema_at(
        'SquareStats::Schema',
        {
                debug => 1,
                dump_directory => './lib',
        },
        [$dsn, "$user", "$pass", {}],
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

By default this connects to a server on localhost, using the system user, and
looks at the database 'squarestats'.

=cut

