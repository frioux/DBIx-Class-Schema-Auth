package DBIx::Class::Schema::Auth::App;

use Moo;
use autodie;
use JSON;

extends 'App::Cmd';

use JSON;

my $c;
use Lynx::SMS;
use DBIx::Class::Schema::AuthTool;
my $s = Lynx::SMS->model('DB')->schema;
my $tool = DBIx::Class::Schema::AuthTool->new(
   schema => $s,
   user_info => sub { print " --- $_[1]\n" },
   user_warn => sub { print " !!! $_[1]\n" },
   user_transformer => sub {
      $_[1]->{$_} ||= '--' for (qw(first_name last_name email));
      $_[1]->{password} ||= 'test';
      $_[1]->{is_active} //= 1;
   },
);

sub get_config { $c = do { local(@ARGV, $/) = 'script/auth.json'; decode_json(<>) } }
sub config { $c }
sub store_config {
   my $self = shift;

   open my $fh, '>', 'script/auth.json';
   print {$fh} to_json($c, { pretty => 1, canonical => 1 });
}

sub auth { $tool }

1;

