use strict;
use warnings;

use Test::More;

use DBIx::Class::Schema::Auth;

{
   package A::Schema;

   use parent 'DBIx::Class::Schema';

   1;
}

A::Schema->load_components('Schema::AuthComponent');
my $auth = DBIx::Class::Schema::Auth->new( schema => 'A::Schema' );
A::Schema->auth->setup_default_rels;
warn A::Schema->auth->user_class;
use Devel::Dwarn;
Dwarn [A::Schema->sources];
Dwarn [A::Schema->class('User')->relationships];
