package DBIx::Class::Schema::Auth::App;

use Moo;
use autodie;
use JSON;

extends 'App::Cmd';

has auth => (
   is => 'ro',
   required => 1,
);

has config => (
   is => 'ro',
   lazy => 1,
   builder => '_build_config',
);

has config_location => (
   is => 'ro',
   required => 1,
);

sub _build_config { local(@ARGV, $/) = $_[0]->config_location; decode_json(<>) }

sub store_config {
   my $self = shift;

   open my $fh, '>', $self->config_location;
   print {$fh} to_json($self->config, { pretty => 1, canonical => 1 });
}

sub execute_command {
   my $self = shift;

   my $guard = $self->auth->schema->txn_scope_guard;

   $self->next::method(@_);

   $guard->commit;
}

1;

