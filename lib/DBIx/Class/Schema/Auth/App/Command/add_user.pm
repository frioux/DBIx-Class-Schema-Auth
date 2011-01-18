package DBIx::Class::Schema::Auth::App::Command::add_user;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'add a new user to the database and the population file' }

sub usage_desc {
   'dbic-auth add_user <name> <role1> [<role2> <role3> ...]'
}
  sub opt_spec {
    return (
      [ 'first-name|l',  'first name' ],
      [ 'last-name|f',  'last name' ],
      [ 'email|e',  'email' ],
    );
  }
sub validate_args {
  my ($self, $opt, $args) = @_;

  $self->usage_error('you forgot to pass a user name!') unless @$args;
  $self->usage_error('you forgot to pass at least one permission spec!')
    unless @$args >= 2;
}

sub execute {
   my ($self, $opt, $args) = @_;
   my ($name, @perm_exprs) = @$args;

   $self->app->auth->add_user($name, $opt, @perm_exprs);
   $self->app->config->{users}{$name} = {
      %$opt,
      roles => \@perm_exprs,
   };
   $self->app->store_config;
}

1;

