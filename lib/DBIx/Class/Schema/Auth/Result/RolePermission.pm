package DBIx::Class::Schema::Auth::Result::RolePermission;

use DBIx::Class::Candy;

table 'roles_permissions';

column role_id => {
   data_type         => 'integer',
   is_numeric        => 1,
   is_nullable       => 0,
};

column permission_id => {
   data_type         => 'integer',
   is_numeric        => 1,
   is_nullable       => 0,
};

primary_key qw(role_id permission_id);

1;
