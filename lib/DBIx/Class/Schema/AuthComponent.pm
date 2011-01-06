package DBIx::Class::Schema::AuthComponent;

use DBIx::Class::Schema::Auth;

use parent qw(Class::Accessor::Grouped DBIx::Class::Helper::Schema::GenerateSource);

__PACKAGE__->mk_group_accessors( cag_bleh => 'auth' );

sub get_cag_bleh {
  my ($self, $bleh) = @_;

  my $use = $self->get_inherited($bleh);
  return defined $use
    ? $use
    : do {
      my $auth = DBIx::Class::Schema::Auth->new( schema => $self );
      $self->set_inherited($bleh, $auth);
      $auth;
    }
  ;
}

1;
