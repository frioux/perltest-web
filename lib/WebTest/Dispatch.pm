package WebTest::Dispatch;
use base 'CGI::Application::Dispatch';
use strict;
use warnings;

sub dispatch_args {
   return {
      prefix => 'WebTest',
      table  => [
         q{}         => { app => 'Controller', rm => 'main' },
         ':app/:rm?' => {},
      ],
   };
}

1;
