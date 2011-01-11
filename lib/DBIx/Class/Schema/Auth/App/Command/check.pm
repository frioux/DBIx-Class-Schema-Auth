package DBIx::Class::Schema::Auth::App::Command::check;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'ensure that there are no extra/missing permissions' }

sub usage_desc { 'dbic-auth check' }

sub execute {}

1;

