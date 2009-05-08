package WebTest::Controller;
use strict;
use warnings;
use base 'CGI::Application';
use WebTest::Tester;

sub cgiapp_init {
   my $self = shift;
   $self->run_modes([qw/main/]);
   $self->start_mode('main');
}

sub tester {
   my $self = shift;
   if ( !$self->param('tester') ) {
      $self->param( 'tester',
         WebTest::Tester->new( { directory => $self->param('dir') || q{.} } ) );
   }
   return $self->param('tester');
}

sub main {
   my $self   = shift;
   my $output = <<'HTML';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
 <title>Tested!!!!</title>
</head>
<body><pre>
HTML

   $output .= $self->tester->tests;
   $output .= <<'HTML';
</pre>
</body>
</html>
HTML

   return $output;
}

1;
