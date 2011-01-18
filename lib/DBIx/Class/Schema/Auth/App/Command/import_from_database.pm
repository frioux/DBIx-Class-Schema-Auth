package DBIx::Class::Schema::Auth::App::Command::import_from_database;

use DBIx::Class::Schema::Auth::App -command;
use JSON;

use strict;
use warnings;

sub abstract { 'import permissions, users, etc from database' }

sub usage_desc { 'dbic-auth import_from_database' }

sub opt_spec { ( [ 'to-file|f=s', 'file' ] ) }

sub execute {
   my ($self, $opt, $args) = @_;

   my $s = $self->app->auth->schema;

   my $out = {
      permissions => [ $s->resultset('Permission')->get_column('name')->all ],
      roles => {
         map { $_->name => [$_->permissions->get_column('name')->all] }
            $s->resultset('Role')->all
      },
      screens => {
         map {
            $_->name => {
               permissions => [$_->permissions->get_column('name')->all ],
               section => $_->section->name,
               xtype => $_->xtype,
            }
         } $s->resultset('Screen')->all
      },
      sections => [ $s->resultset('Section')->get_column('name')->all ],
      users => {
         map {
            $_->username => {
               first_name => $_->first_name,
               last_name => $_->last_name,
               email => $_->email,
               roles => [$_->roles->get_column('name')->all],
            }
         } $s->resultset('User')->all
      }
   };

   open my $fh, '>', $opt->to_file || $self->app->config_location;
   print {$fh} to_json($out, { pretty => 1, canonical => 1 });
}

1;

