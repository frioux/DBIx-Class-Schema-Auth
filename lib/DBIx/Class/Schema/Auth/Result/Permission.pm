package DBIx::Class::Schema::Auth::Result::Permission;

use DBIx::Class::Candy;

table 'permissions';

column id => {
   data_type         => 'integer',
   is_numeric        => 1,
   is_auto_increment => 1,
};

column name => {
   data_type   => 'varchar',
   size        => 50,
   is_nullable => 0,
};

primary_key 'id';

unique_constraint 'name';

1;
