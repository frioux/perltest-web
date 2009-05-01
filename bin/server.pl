#!/usr/bin/perl

use strict;
use warnings;
use feature ':5.10';
use IO::All;
use Carp;
use Readonly;
Readonly my $PORT => 7891;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WebTest::Tester;
use JSON 'encode_json';

my $dir = shift or croak "no directory passed in";
my $port = shift || $PORT;

my $socket = io(":$port") or croak "server couldn't load on port $port";
say "server loaded on port $port";

my $tester = WebTest::Tester->new( { directory => $dir } );
while ( my $s = $socket->accept ) {
   say 'Servicing client';
   $s->print( encode_json { data => $tester->tests }  );
}
