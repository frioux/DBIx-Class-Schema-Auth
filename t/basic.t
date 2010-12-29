use strict;
use warnings;

use Test::More;

use DBIx::Class::Schema::Auth;

{
   package A::Schema;

   use parent 'DBIx::Class::Schema';

   1;
}

my $auth = DBIx::Class::Schema::Auth->new( schema => 'A::Schema' );
$auth->setup_default_rels;
warn $auth->user_class;
use Devel::Dwarn;
Dwarn [A::Schema->sources];
Dwarn [A::Schema->class('User')->relationships];
