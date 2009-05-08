package WebTest::Tester;
use Moose;
use File::Find::Rule;
use TAP::Parser;
use File::Spec;

has directory => (
   is       => 'rw',
   isa      => 'Str',
   required => 1,
   reader   => 'get_directory',
   writer   => 'set_directory',
);

sub test {
   my $self = shift;
   my $file = shift;
   my @total_results;
   my $tap_output = qx{perl $file 2>&1};
   my $parser = TAP::Parser->new( { tap => $tap_output } );
   while ( my $result = $parser->next ) {
      push @total_results, $result->as_string;
   }
   return @total_results;
}

sub tests {
   my $self = shift;
   my @files = File::Find::Rule->file()->name('*.t')->maxdepth( 1 )
      ->in( File::Spec->catdir( $self->get_directory, 't' ) );

   return join "\n", map {
      ( $_, $self->test( $_ ) );
   } @files;
}

no Moose;
__PACKAGE__->meta->make_immutable;

