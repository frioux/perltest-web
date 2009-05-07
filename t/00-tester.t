#!perl

use strict;
use warnings;
use Test::More tests => 4;
use Test::Exception;
use FindBin;
use lib "$FindBin::Bin/../lib";

BEGIN { use_ok 'WebTest::Tester'; };

throws_ok { WebTest::Tester->new() }
   qr/Attribute \(directory\) is required/sm,
   q{didn't pass directory into constructor};

my $tester = WebTest::Tester->new({
      directory => q{t/test_files}
   });

ok defined $tester && ref $tester eq 'WebTest::Tester',
   'new() works';

ok $tester->get_directory eq q{t/test_files}, 'get_directory() works';
TODO: {
   local $TODO = 'unpossable';
is_deeply $tester->tests, [], 'should find errors in test file';
}

