package DBIx::Class::Schema::Auth;

use Moo;

use Scalar::Util 'blessed';

has schema => (
   is => 'ro',
   required => 1,
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

sub _build_class {
   my ($class, @name) = @_;

   my $moniker = join '', map ucfirst, @name;
   my $method = 'generate_' . ( join '_', map lc, @name ) . '_class';

   return sub { $_[0]->$method; $_[0]->schema->class($moniker) }
}

sub _generate_class {
   my ($class, $which) = @_;

   return sub {
      my $self = shift;

      $self->schema->generate_source(
         $which => "DBIx::Class::Schema::Auth::Result::$which"
      ) unless scalar grep { $which eq $_ } $self->schema->sources
   }
}

{
   no strict 'refs';
   *generate_permission_class        = __PACKAGE__->_generate_class('Permission');
   *generate_permission_screen_class = __PACKAGE__->_generate_class('PermissionScreen');
   *generate_role_class              = __PACKAGE__->_generate_class('Role');
   *generate_role_permission_class   = __PACKAGE__->_generate_class('RolePermission');
   *generate_screen_class            = __PACKAGE__->_generate_class('Screen');
   *generate_section_class           = __PACKAGE__->_generate_class('Section');
   *generate_user_class              = __PACKAGE__->_generate_class('User');
   *generate_user_role_class         = __PACKAGE__->_generate_class('UserRole');

   *_build_permission_class        = __PACKAGE__->_build_class('permission');
   *_build_permission_screen_class = __PACKAGE__->_build_class(qw(permission screen));
   *_build_role_class              = __PACKAGE__->_build_class('role');
   *_build_role_permission_class   = __PACKAGE__->_build_class(qw(role permission));
   *_build_screen_class            = __PACKAGE__->_build_class('screen');
   *_build_section_class           = __PACKAGE__->_build_class('section');
   *_build_user_class              = __PACKAGE__->_build_class('user');
   *_build_user_role_class         = __PACKAGE__->_build_class(qw(user role));
}

sub setup_role_to_permissions {
   my $self = shift;

   $self->permission_class->has_many(
      role_permissions => $self->role_permission_class, 'permission_id',
   );
   $self->permission_class->many_to_many( roles => 'role_permissions', 'role' );
   $self->role_permission_class->belongs_to( role => $self->role_class, 'role_id');
   $self->role_permission_class->belongs_to( permission => $self->permission_class, 'permission_id');
   $self->role_class->has_many( role_permissions => $self->role_permission_class, 'role_id' );
   $self->role_class->many_to_many( permissions => 'role_permissions', 'permission' );
}

sub setup_user_to_roles {
   my $self = shift;

   $self->user_class->has_many( user_roles => $self->user_role_class, 'user_id' );
   $self->user_class->many_to_many( roles => 'user_roles', 'role' );
   $self->role_class->has_many( user_roles => $self->user_role_class, 'role_id' );
   $self->role_class->many_to_many( users => 'user_roles', 'user' );
   $self->user_role_class->belongs_to( role => $self->role_class, 'role_id' );
   $self->user_role_class->belongs_to( user => $self->user_class, 'user_id' );
}

sub setup_permission_to_screens {
   my $self = shift;

   $self->permission_class->has_many(
      permission_screens => $self->permission_screen_class, 'permission_id',
   );
   $self->permission_class->many_to_many( screens => 'permission_screens', 'screen' );
   $self->permission_screen_class->belongs_to( screen => $self->screen_class, 'screen_id' );
   $self->permission_screen_class->belongs_to( permission => $self->permission_class, 'permission_id' );
   $self->screen_class->has_many( permission_screens => $self->permission_screen_class, 'screen_id' );
   $self->screen_class->many_to_many( permissions => 'permission_screens', 'permission' );
}

sub setup_section_to_screen {
   my $self = shift;

   $self->screen_class->belongs_to( section => $self->section_class, 'section_id' );
   $self->section_class->has_many( screens => $self->screen_class, 'section_id' );
}

sub setup_default_rels {
   my $self = shift;

   $self->setup_user_to_roles;
   $self->setup_role_to_permissions;
   $self->setup_permission_to_screens;
   $self->setup_section_to_screen;
}

1;
