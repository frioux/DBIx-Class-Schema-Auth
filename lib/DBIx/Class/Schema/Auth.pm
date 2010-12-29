package DBIx::Class::Schema::Auth;

use Moo;

use Scalar::Util 'blessed';

has schema => (
   is => 'ro'
);

has schema_class => (
   is      => 'ro',
   lazy    => 1,
   builder => '_build_schema_class',
);

sub _build_schema_class { blessed($_[0]->schema) || $_[0]->schema }

has $_ . '_class' => (
   is      => 'ro',
   lazy    => 1,
   builder => '_build_' . $_ . '_class',
) for qw(
   permission permission_screen role role_permission screen section user
   user_role
);

sub _generate_class_name {
   my $self = shift;
   my $which = shift;

   $self->schema_class.'::GeneratedResult::__' . uc $which;
}

sub _generate_class {
   my $self  = shift;
   my $class_name = shift;
   my $which = shift;

   eval "package $class_name; use base 'DBIx::Class::Schema::Auth::Result::$which'; 1";
}

sub _build_class {
   my $class = shift;
   my $which = shift;

   return sub {
      my $self = shift;

      if (my ($src) = grep { $which eq $_ } $self->schema->sources) {
         return $self->class($which)
      } else {
         my $class_name = $self->_generate_class_name($which);
         $self->_generate_class($class_name, $which);
         $self->schema->register_class($which, $class_name);
         return $class_name
      }
   }
}

{
   no strict 'refs';
   *_build_permission_class        = __PACKAGE__->_build_class('Permission');
   *_build_permission_screen_class = __PACKAGE__->_build_class('PermissionScreen');
   *_build_role_class              = __PACKAGE__->_build_class('Role');
   *_build_role_permission_class   = __PACKAGE__->_build_class('RolePermission');
   *_build_screen_class            = __PACKAGE__->_build_class('Screen');
   *_build_section_class           = __PACKAGE__->_build_class('Section');
   *_build_user_class              = __PACKAGE__->_build_class('User');
   *_build_user_role_class         = __PACKAGE__->_build_class('UserRole');
}


sub setup_default_rels {
   my $self = shift;

   $self->user_class->has_many( user_roles => $self->user_role_class, 'user_id' );
   $self->user_class->many_to_many( roles => 'user_roles', 'role' );

   $self->permission_class->has_many(
      role_permissions => $self->role_permission_class, 'permission_id',
   );
   $self->permission_class->has_many(
      permission_screens => $self->permission_screen_class, 'permission_id',
   );
   $self->permission_class->many_to_many( roles => 'role_permissions', 'role' );
   $self->permission_class->many_to_many( screens => 'permission_screens', 'screen' );

   $self->permission_screen_class->belongs_to( screen => $self->screen_class, 'screen_id' );
   $self->permission_screen_class->belongs_to( permission => $self->permission_class, 'permission_id' );

   $self->role_class->has_many( role_permissions => $self->role_permission_class, 'role_id' );
   $self->role_class->has_many( user_roles => $self->user_role_class, 'role_id' );
   $self->role_class->many_to_many( permissions => 'role_permissions', 'permission' );
   $self->role_class->many_to_many( users => 'user_roles', 'user' );

   $self->role_permission_class->belongs_to( role => $self->role_class, 'role_id');
   $self->role_permission_class->belongs_to( permission => $self->permission_class, 'permission_id');

   $self->screen_class->belongs_to( section => $self->section_class, 'section_id' );
   $self->screen_class->has_many( permission_screens => $self->permission_screen_class, 'screen_id' );
   $self->screen_class->many_to_many( permissions => 'permission_screens', 'permission' );

   $self->section_class->has_many( screens => $self->screen_class, 'section_id' );

   $self->user_role_class->belongs_to( role => $self->role_class, 'role_id' );
   $self->user_role_class->belongs_to( user => $self->user_class, 'user_id' );
}

1;
