package DBIx::Class::Schema::Auth::App::Command::add_role;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'add a new role to the database and the population file' }

sub usage_desc { 'dbic-auth add_role <name> <perm1> [<perm2> <perm3> ...]' }

sub validate_args {
  my ($self, $opt, $args) = @_;

  $self->usage_error('you forgot to pass a role name!') unless @$args;
  $self->usage_error('you forgot to pass at least one permission spec!')
    unless @$args >= 2;
}

sub execute {
   my ($self, $opt, $args) = @_;

   $self->app->auth->add_role(@$args)
}

1;

