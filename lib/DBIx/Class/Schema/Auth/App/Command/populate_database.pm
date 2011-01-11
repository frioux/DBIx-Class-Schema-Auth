package DBIx::Class::Schema::Auth::App::Command::populate_database;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'populate the database with info in the population file' }

sub usage_desc { 'dbic-auth populate_database' }

sub execute {}

1;

