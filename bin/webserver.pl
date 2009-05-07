#!perl
use strict;
use warnings;
use CGI::Application::Server;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WebTest::Dispatch;

my $server = CGI::Application::Server->new(5052);

$server->entry_points({
      '/tests'     => 'WebTest::Dispatch',
      '/static'    => '/',
   });
$server->document_root("$FindBin::Bin/../static");
$server->run();
