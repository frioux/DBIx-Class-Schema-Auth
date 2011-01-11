package DBIx::Class::Schema::Auth::App::Command::import_from_database;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'import permissions, users, etc from database' }

sub usage_desc { 'dbic-auth import_from_database [--to-file <file>]' }

sub execute {}

1;

