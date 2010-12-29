package DBIx::Class::Schema::Auth::Result::Session;

use DBIx::Class::Candy;

table 'session';

column id => {
   data_type => 'char',
   size      => 72,
};

column session_data => {
   data_type => 'text',
   is_nullable => 1,
};

column expires => {
   data_type   => 'integer',
   is_nullable => 1,
};

primary_key 'id';

1;

