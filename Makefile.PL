use inc::Module::Install;
name 'Yakeiseiza';
all_from 'lib/Yakeiseiza.pm';

requires 'Ark';
requires 'Path::Class';
requires 'File::Copy';
requires 'Facebook::Graph';
requires 'URI::Escape';
requires 'FindBin::libs';
requires 'Cache::FastMmap';
requires 'DBIx::Class::DigestColumns';
requires 'Digest::SHA1';

tests 't/*.t';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
