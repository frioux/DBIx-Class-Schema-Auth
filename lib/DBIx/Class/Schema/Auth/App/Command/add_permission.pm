package DBIx::Class::Schema::Auth::App::Command::add_permission;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'add a new permission to the database and the population file' }

sub usage_desc { 'dbic-auth add_permission <name>' }

sub validate_args {
  my ($self, $opt, $args) = @_;

  $self->usage_error('you forgot to pass a permission name!') unless @$args;
}

sub execute {
   my ($self, $opt, $args) = @_;

   $self->app->auth->add_permission($args->[0])
}

1;

