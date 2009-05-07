#!perl
use strict;
use warnings;
use CGI::Application::Server;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WebTest::Controller;
use Readonly;
Readonly my $port => shift || 5052;
Readonly my $dir  => shift || q{.};

my $server = CGI::Application::Server->new($port);
my $app    = WebTest::Controller->new( PARAMS => {
   dir => $dir
});

$server->entry_points({ '/tests' => $app });
$server->document_root("$FindBin::Bin/../static");
$server->run();

