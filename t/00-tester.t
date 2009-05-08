#!perl

use strict;
use warnings;
use Test::More tests => 7;
use Test::Exception;
use Test::Differences;
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
{
   my @pass_expected = (
      q{<span class='plan'>1..1</span>},
      q{<span class='passed-test'>ok 1 - should pass</span>},
   );

   my @fail_expected = (
      q{<span class='plan'>1..1</span>},
      q{<span class='failed-test'>not ok 1 - should fail</span>},
      q{<span class='comment'>#   Failed test 'should fail'</span>},
      q{<span class='comment'>#   at t/test_files/t/fail.t line 3.</span>},
      q{<span class='comment'># Looks like you failed 1 test of 1.</span>},
   );

   is_deeply $tester->test( 't/test_files/t/pass.t' ), \@pass_expected, 'pass passed';
   is_deeply $tester->test( 't/test_files/t/fail.t' ), \@fail_expected, 'fail failed';

   my $expected =
      qq{<span class='file'>t/test_files/t/pass.t</span>\n}.join( q{}, map { "$_\n" } @pass_expected ).
      qq{<span class='file'>t/test_files/t/fail.t</span>\n}.join( q{}, map { "$_\n" } @fail_expected );
   eq_or_diff $tester->tests.qq{\n}, $expected, 'should test stuff';
}
