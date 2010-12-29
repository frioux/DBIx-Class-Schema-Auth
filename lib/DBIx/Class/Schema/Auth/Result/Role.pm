package DBIx::Class::Schema::Auth::Result::Role;

use DBIx::Class::Candy;

table 'roles';

column id => {
   data_type         => 'int',
   is_auto_increment => 1,
};

column name => {
   data_type   => 'varchar',
   size        => 50,
};

primary_key 'id';

1;
