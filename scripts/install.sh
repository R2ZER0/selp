#!/bin/bash

# This script will install everything needed to run the website

# Before running this, make sure you have installed:
# * gcc
# * patch
# * make
# and the perl module ExtUtils::MakeMaker, on CentOS etc this is available
# as: yum install perl-ExtUtils-MakeMaker
#
# These should all be installed on DICE

# If we are unable to install packages, try a different mirror:
# By default i am using my own mirror of CPAN, to ensure that we have the same
# versions of all the modules - also, it is a lot faster.
MYCPANM="cpanm --verbose --mirror-only --mirror http://gallium.r2zer0.net/minicpan/"
#MYCPANM="cpanm --verbose"  # Use public mirrors (possibly slower)

export POSTGRES_HOME="/usr/pgsql-9.3"

# Install perlbrew
\curl -L http://install.perlbrew.pl | bash

# Activate perlbrew
source ~/perl5/perlbrew/etc/bashrc

# Install cpanm
perlbrew install-cpanm

# Install perl
# Warning! This takes a long time! (--notest makes it much faster, however)
perlbrew --notest install perl-5.20.0

# Activate this perl dist
perlbrew switch perl-5.20.0

# Dist::Zilla build tool
$MYCPANM Dist::Zilla

# Dependancies for the scripts
$MYCPANM FindBin
$MYCPANM File::Slurp
$MYCPANM Log::Any::Adapter::Stdout

# Used for generating mock data for the db
$MYCPANM Mock::Person::US

# Dependancies for SquareStats::App
$MYCPANM Catalyst::Runtime
$MYCPANM Catalyst::Devel
$MYCPANM Catalyst::ScriptRunner
$MYCPANM Catalyst::Restarter
$MYCPANM Catalyst::Plugin::Session::State::Cookie
$MYCPANM Catalyst::Plugin::Session::Store::File
$MYCPANM Catalyst::Plugin::Authentication
$MYCPANM Catalyst::Plugin::Redirect
$MYCPANM Catalyst::Authentication::Realm::SimpleDB
$MYCPANM Catalyst::View::TT
$MYCPANM DBIx::Class::PassphraseColumn
$MYCPANM dists/SquareStats-Schema-0.005.tar.gz
