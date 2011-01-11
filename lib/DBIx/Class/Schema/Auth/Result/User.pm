package DBIx::Class::Schema::Auth::Result::User;

use DBIx::Class::Candy -components => ['EncodedColumn'];

table 'users';

column id => {
   data_type         => 'integer',
   is_auto_increment => 1,
};

column username => {
   data_type => 'varchar',
   size      => 50,
};

column first_name => {
   data_type => 'varchar',
   size      => 50,
};

column last_name => {
   data_type => 'varchar',
   size      => 50,
};

column email => {
   data_type => 'varchar',
   size      => 320,
};

column is_first_login => {
   data_type     => 'bit',
   size          => 1,
   default_value => 1,
};

column password => {
   is_serializable => 0,
   data_type           => 'char',
   size                => 59,
   encode_column       => 1,
   encode_class        => 'Crypt::Eksblowfish::Bcrypt',
   encode_args         => { key_nul => 0, cost => 8 },
   encode_check_method => 'check_password',
};

primary_key 'id';

1;
