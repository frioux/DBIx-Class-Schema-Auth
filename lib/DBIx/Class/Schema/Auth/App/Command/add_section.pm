package DBIx::Class::Schema::Auth::App::Command::add_section;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'add a new section to the database and the population file' }

sub usage_desc { 'dbic-auth add_section <name>' }

sub validate_args {
  my ($self, $opt, $args) = @_;

  $self->usage_error('you forgot to pass a section name!') unless @$args;
}

sub execute {
   my ($self, $opt, $args) = @_;

   $self->app->auth->add_section($args->[0]);

   $self->app->get_config;
   push @{$self->app->config->{sections}}, $args->[0];
   $self->app->store_config;
}

1;

