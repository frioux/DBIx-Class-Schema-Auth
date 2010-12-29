package DBIx::Class::Schema::Auth::Result::PermissionScreen;

use DBIx::Class::Candy;

table 'permission_screens';

column permission_id => { data_type => 'integer' };

column screen_id => { data_type => 'integer' };

primary_key qw(permission_id screen_id);

1;
