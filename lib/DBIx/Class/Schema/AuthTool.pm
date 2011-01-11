package DBIx::Class::Schema::AuthTool;

use Moo;

has schema => (
   is => 'ro',
   weaken => 1,
   required => 1,
);

has $_ => (
   is      => 'ro',
   lazy    => 1,
   builder => '_build_' . $_,
) for qw( permissions roles screens sections users );

sub _build_permissions { $_[0]->schema->resultset('Permission') }
sub _build_roles { $_[0]->schema->resultset('Role') }
sub _build_screens { $_[0]->schema->resultset('Screen') }
sub _build_sections { $_[0]->schema->resultset('Section') }
sub _build_users { $_[0]->schema->resultset('User') }

sub transform_permission_hashref {}
sub transform_role_hashref {}
sub transform_user_hashref {}
sub transform_section_hashref {}
sub transform_screen_hashref {}

sub add_permission {
   my ($self, $name) = @_;

   my $hashref = { name => $name };

   $self->transform_permission_hashref($hashref);

   $self->permissions->create($hashref)
}

sub add_role {
   my ($self, $name, @perm_expr) = @_;

   my $hashref = { name => $name };

   $self->transform_role_hashref($hashref);

   my $role = $self->roles->create($hashref);

   my @perms = $self->permissions
      ->search({ 'me.name' => { -like => \@perm_expr } })->all;

   if (@perms) {
      $role->add_to_permissions($_) for @perms;
   } else {
      warn "No permissions found for role $name";
   }

   return $role;
}

sub add_user {
   my ($self, $name, $opt, @role_expr) = @_;

   my $hashref = {
      username => $name,
      %{$opt||{}},
   };

   $self->transform_user_hashref($hashref);

   my $user = $self->users->create($hashref);

   my @roles = $self->roles
      ->search({ 'me.name' => { -like => \@role_expr } })->all;

   if (@roles) {
      $user->add_to_roles($_) for @roles;
   } else {
      warn "No roles found for user $name";
   }

   return $user
}

sub add_section {
   my ($self, $name) = @_;

   my $hashref = { name => $name };

   $self->transform_screen_hashref($hashref);

   $self->sections->create($hashref)
}

sub add_screen {
   my ($self, $name, $section_expr, $opt, @perm_expr ) = @_;

   my $section = $self->sections->search({
      'me.name' => { -like => $section_expr }
   })->single or die "No section matching $section_expr";

   my $hashref = {
      name => $name,
      section => $section,
      %$opt,
   };

   $self->transform_screen_hashref($hashref);

   my $screen = $self->screens->create($hashref);

   my @perms = $self->permissions
      ->search({ name => { -like => \@perm_expr } })->all;

   if (@perms) {
      $screen->add_to_permissions($_) for @perms;
   } else {
      warn "No permissions found for screen $name";
   }

   $screen
}

1;

