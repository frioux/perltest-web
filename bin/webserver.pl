#!perl
use strict;
use warnings;
use CGI::Application::Server;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WebTest::Controller;

my $server = CGI::Application::Server->new(5052);
my $app    = WebTest::Controller->new( PARAMS => {
   dir => q{.}
});

$server->entry_points({ '/tests' => $app });
$server->document_root("$FindBin::Bin/../static");
$server->run();

