package DBIx::Class::Schema::AuthTool;

use Moo;
use Sub::Quote;

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

has "_${_}_xformer" => (
   is      => 'ro',
   init_arg => "${_}_transformer",
   default => quote_sub q< sub {} >,
) for qw(permission role user section screen);

has '_user_warn' => (
   is      => 'ro',
   init_arg => 'user_warn',
   default => quote_sub q< sub { warn $_[1] } >,
);

sub user_warn { $_[0]->_user_warn->($_[0], $_[1]) }

has '_user_info' => (
   is      => 'ro',
   init_arg => 'user_info',
   default => quote_sub q< sub { warn $_[1] } >,
);

sub user_info { $_[0]->_user_info->($_[0], $_[1]) }

sub transform_permission_hashref { $_[0]->_permission_xformer->($_[0], $_[1]) }
sub transform_role_hashref { $_[0]->_role_xformer->($_[0], $_[1]) }
sub transform_user_hashref { $_[0]->_user_xformer->($_[0], $_[1]) }
sub transform_section_hashref { $_[0]->_section_xformer->($_[0], $_[1]) }
sub transform_screen_hashref { $_[0]->_screen_xformer->($_[0], $_[1]) }

sub add_permission {
   my ($self, $name) = @_;

   my $hashref = { name => $name };

   $self->transform_permission_hashref($hashref);

   $self->permissions->find_or_create($hashref)
}

sub add_role {
   my ($self, $name, @perm_expr) = @_;

   my $hashref = { name => $name };

   $self->transform_role_hashref($hashref);

   my $role = $self->roles->find_or_create($hashref);

   my @perms = $self->permissions
      ->search({ 'me.name' => { -like => \@perm_expr } })->all;

   $self->schema->resultset('RolePermission')->search({ role_id => $role->id })->delete;
   if (@perms) {
      $role->add_to_permissions($_) for @perms;
   } else {
      $self->user_warn("No permissions found for role $name");
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

   my $user = $self->users->find_or_create($hashref);

   my @roles = $self->roles
      ->search({ 'me.name' => { -like => \@role_expr } })->all;

   $self->schema->resultset('UserRole')->search({ user_id => $user->id })->delete;
   if (@roles) {
      $user->add_to_roles($_) for @roles;
   } else {
      $self->user_warn("No roles found for user $name");
   }

   return $user
}

sub add_section {
   my ($self, $name) = @_;

   my $hashref = { name => $name };

   $self->transform_screen_hashref($hashref);

   $self->sections->find_or_create($hashref)
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

   my $screen = $self->screens->find_or_create($hashref);

   my @perms = $self->permissions
      ->search({ name => { -like => \@perm_expr } })->all;

   $self->schema->resultset('PermissionScreen')->search({ screen_id => $screen->id })->delete;
   if (@perms) {
      $screen->add_to_permissions($_) for @perms;
   } else {
      $self->user_warn("No permissions found for screen $name");
   }

   $screen
}

sub populate {
   my ($self, $auth) = @_;

   $self->user_info('populating permissions');

   $self->add_permission($_) for @{$auth->{permissions}};

   $self->user_info('populating roles');
   $self->add_role($_,
      (ref ( $auth->{roles}{$_} ) ? @{ $auth->{roles}{$_} } : $auth->{roles}{$_} )
   ) for keys %{$auth->{roles}};

   $self->user_info('populating users');
   for my $name (keys %{$auth->{users}}) {
      my $result = $auth->{users}{$name};

      my $type = ref $result;

      my ($user_args, @role_expr) = ({});

      if (defined $type && $type eq 'HASH') {
         my $r = delete $result->{roles};
         @role_expr = (ref $r ? @$r : $r);
         $user_args = $result;
      } elsif (defined $type && $type eq 'ARRAY') {
         @role_expr = @$result;
      } elsif (!$type) {
         @role_expr = ($result);
      }

      $self->add_user($name, $user_args, @role_expr);
   }

   $self->user_info('populating sections');
   $self->add_section($_) for @{$auth->{sections}};

   $self->user_info('populating screens');
   $self->add_screen(
      $_, $auth->{screens}{$_}{section}, {
         xtype => $auth->{screens}{$_}{xtype}
      }, (ref $auth->{screens}{$_}{permissions} ? @{ $auth->{screens}{$_}{permissions} } : $auth->{screens}{$_}{permissions} )
   ) for keys %{$auth->{screens}};
}

1;

