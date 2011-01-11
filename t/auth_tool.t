use strict;
use warnings;

use Test::More;

{
   package A::Schema;

   use parent 'DBIx::Class::Schema';

   __PACKAGE__->load_components('Schema::AuthComponent');
   __PACKAGE__->auth->setup_default_rels;

   1;
}

my $s = A::Schema->connect('dbi:SQLite:dbname=:memory:');
$s->deploy;

my $at = $s->auth_tool;

$at->add_permission($_) for (qw( P/foo P/bar P/baz ));
$at->add_role('R/all' => qw( % ));
$at->add_role('R/b' => qw( P/b% ));
$at->add_user(frew => {
   first_name => 'frew',
   last_name => 'frew',
   email => 'frew',
   password => 'lol',
}, qw( % ));
$at->add_user(wes => qw( R/b ));
