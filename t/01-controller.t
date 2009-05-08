#!perl

use strict;
use warnings;
use Test::More tests => 1;
use Test::WWW::Mechanize::CGIApp;
use FindBin;
use lib "$FindBin::Bin/../lib";
my $mech = Test::WWW::Mechanize::CGIApp->new;

$mech->app(
   sub {
      use WebTest::Controller;
      my $app = WebTest::Controller->new(PARAMS => { dir => "$FindBin::Bin/test_files" });
      $app->run();
   });

$mech->get_ok( '?rm=main' );

