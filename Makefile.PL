# IMPORTANT: if you delete this file your app will not work as
# expected.  you have been warned
use inc::Module::Install;

name 'MTSI';

requires 'Catalyst::Runtime' => '5.80007';
version (1.0);
#requires 'Catalyst::TraitFor::Controller::DBIC::DoesPaging';
#requires 'Catalyst::TraitFor::Controller::DoesExtPaging';
requires 'Crypt::Eksblowfish::Bcrypt';
requires 'Catalyst::Model::DBIC::Schema';
requires 'DBIx::Class';
requires 'DBIx::Class::EncodedColumn';
requires 'DBIx::Class::Validation';
requires 'Method::Signatures::Simple';
requires 'Moose::Autobox';
requires 'DBIx::Class::InflateColumn::Serializer';
requires 'Log::Contextual';
requires 'Try::Tiny';
requires 'namespace::autoclean';
requires 'Email::Sender::Simple';
requires 'Config::JFDI';

requires 'CLASS';

WriteAll;
