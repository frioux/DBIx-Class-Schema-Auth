package DBIx::Class::Schema::Auth::Result::Section;

use DBIx::Class::Candy;

table 'sections';

column id => {
   data_type         => 'int',
   is_auto_increment => 1,
};

column name => {
   data_type => 'varchar',
   size      => 50,
};

primary_key 'id';

1;
