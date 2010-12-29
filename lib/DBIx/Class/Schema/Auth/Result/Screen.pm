package DBIx::Class::Schema::Auth::Result::Screen;

use DBIx::Class::Candy;

table 'screens';

column id => {
   data_type         => 'int',
   is_auto_increment => 1,
};

column name => {
   data_type => 'varchar',
   size      => 50,
};

column section_id => { data_type => 'integer' };

column xtype => {
   data_type => 'varchar',
   size      => 50,
};

primary_key 'id';

1;
