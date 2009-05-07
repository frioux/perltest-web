package WebTest::Controller;
use strict;
use warnings;
use base 'CGI::Application';
use feature ':5.10';
use CGI::Application::Plugin::AutoRunmode;
use WebTest::Tester;

sub main : StartRunmode {
   my $self = shift;
   my $output = <<'HTML';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
 <link href="/css/css.css" rel="stylesheet" type="text/css" />
 <title>Tested!!!!</title>
</head>
<body><pre>
HTML

   my $tester = WebTest::Tester->new( { directory => '/home/frew/personal/web_test' } );
   $output .= $tester->tests;
   $output .= <<'HTML';
</pre>
</body>
</html>
HTML

   return $output;
}

1;
