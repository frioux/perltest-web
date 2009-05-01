package WebTest::Controller;
use strict;
use warnings;
use base 'CGI::Application';
use feature ':5.10';
use CGI::Application::Plugin::AutoRunmode;

sub main : StartRunmode {
   my $self = shift;
   my $html        = <<'HTML';
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
   <title>WebTest: for your health!</title>
   <script type="text/javascript" src="/static/js/lib/ext3/adapter/ext/ext-base.js"></script>
   <script type="text/javascript" src="/static/js/lib/ext3/ext-all.js"></script>
   <link rel="stylesheet" type="text/css" href="/static/js/lib/ext3/resources/css/ext-all.css" />
   <link rel="stylesheet" type="text/css" href="/static/css/webtest.css" />
   <script type="text/javascript" src="/static/js/lib/WebTest/TestGrid.js"></script>
   <script type="text/javascript" src="/static/js/main.js"></script>
</head>
<body>
<div id='main'></div>
</body>
</html>
HTML
   return $html;
}

sub tests : Runmode {
   my $self = shift;
   use IO::All;

   my $port = $ENV{ TEST_PORT } || 7891;

   my $io = io("localhost:$port");
   my $output;
   while ( my $line = $io->getline ) {
      $output .= $line;
   }
   return $output;
}

1;
