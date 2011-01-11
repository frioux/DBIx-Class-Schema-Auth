package DBIx::Class::Schema::AuthComponent;

use strict;
use warnings;

use DBIx::Class::Schema::Auth;
use DBIx::Class::Schema::AuthTool;

use parent qw(Class::Accessor::Grouped DBIx::Class::Helper::Schema::GenerateSource);

__PACKAGE__->mk_group_accessors( cag_bleh => 'auth' );
__PACKAGE__->mk_group_accessors( cag_bleh => 'auth_tool' );

sub get_cag_bleh {
  my ($self, $bleh) = @_;

  my $use = $self->get_inherited($bleh);

  if ($bleh eq 'auth') {
     return defined $use
       ? $use
       : do {
         my $auth = DBIx::Class::Schema::Auth->new( schema => $self );
         $self->set_inherited($bleh, $auth);
         $auth;
       };
  } else {
     return $use
  }
}

sub connection {
   my $class = shift;

   my $self = $class->next::method(@_);

   $self->set_inherited(
      auth_tool => DBIx::Class::Schema::AuthTool->new( schema => $self )
   );

   $self
}

1;
