package WebTest::Tester;
use Moose;
use feature ':5.10';

use File::Find::Rule;
use TAP::Parser;
use File::Spec;
use File::stat;
use Carp;

has directory => (
   is       => 'rw',
   isa      => 'Str',
   required => 1,
   reader   => 'get_directory',
   writer   => 'set_directory',
);

sub tests {
   my $self  = shift;
   my @files = File::Find::Rule->file()->name('*.t')
      ->in( File::Spec->catdir( $self->get_directory, 't' ) );

   my @tests;

   foreach my $file (@files) {
      my $parser = TAP::Parser->new( { merge => 1, source => $file } );
      RESULT:
      while ( my $result = $parser->next ) {
         if ( !$result->is_test ) { next RESULT; }
         my $ok = $result->is_ok;

         push @tests, {
            filename     => $file,
            is_ok        => $ok,
            explanation  => $result->explanation,
            number       => $result->number,
            description  => $result->description,
            explanation  => $result->explanation,
            is_planned   => !$result->is_unplanned,
            has_skip     => $result->has_skip,
            has_todo     => $result->has_todo,
         };
      }
   }

   return \@tests;
}

no Moose;
__PACKAGE__->meta->make_immutable;
