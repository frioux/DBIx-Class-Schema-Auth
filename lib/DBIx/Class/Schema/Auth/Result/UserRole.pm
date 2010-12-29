package DBIx::Class::Schema::Auth::Result::UserRole;

use DBIx::Class::Candy;

table 'users_roles';

column user_id => { data_type => 'integer' };

column role_id => { data_type => 'integer' };

primary_key qw(user_id role_id);

1;
