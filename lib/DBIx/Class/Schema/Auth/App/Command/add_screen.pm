package DBIx::Class::Schema::Auth::App::Command::add_screen;

use DBIx::Class::Schema::Auth::App -command;

use strict;
use warnings;

sub abstract { 'add a new screen to the database and the population file' }

sub usage_desc { 'dbic-auth add_screen <name> <xtype> <section> <perm1> [<perm2> <perm3> ...]' }

sub validate_args {
  my ($self, $opt, $args) = @_;

  $self->usage_error('you forgot to pass a screen name (lolz)!') unless @$args;
  $self->usage_error('you forgot to pass an xtype!') unless @$args >= 2;
  $self->usage_error('you forgot to pass a section!') unless @$args >= 3;
  $self->usage_error('you forgot to pass at least one permission spec!') unless @$args >= 4;
}

sub execute {
   my ($self, $opt, $args) = @_;
   my ($name, $xtype, $section, @perms) = (@$args);

   $self->app->auth->add_screen($name, $section, { xtype => $xtype }, @perms)
}

1;

