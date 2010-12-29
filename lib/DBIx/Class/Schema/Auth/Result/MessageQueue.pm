package DBIx::Class::Schema::Auth::Result::MessageQueue;

use DBIx::Class::Candy -components => [qw(InflateColumn::Serializer TimeStamp)];

table 'message_queue';

column id => {
   is_auto_increment => 1,
   data_type         => 'int',
};

column type => {
   data_type => 'varchar',
   size      => 255,
};

column date_arrived => {
   data_type     => 'datetime',
   set_on_create => 1,
};

column data => {
   data_type        => 'text',
   serializer_class => 'JSON'
};

primary_key 'id';

1;
