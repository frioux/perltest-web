package WebTest::Tester;
use Moose;

use File::Find::Rule;
use TAP::Parser;
use TAP::Parser::Aggregator;
use File::Spec;
use File::stat;
use Carp;
use Method::Signatures::Simple;

has directory => (
   is       => 'rw',
   isa      => 'Str',
   required => 1,
   reader   => 'get_directory',
   writer   => 'set_directory',
);

my $formatters = {
   plan => sub {
      my $result = shift;
      return q{<span class='plan'>}.$result->plan.q{</span>};
   },
   test => sub {
      my $result = shift;
      my @ok = ( $result->is_ok )
         ? ( q{<span class='passed-test'>ok},q{</span>} )
         : ( q{<span class='failed-test'>not ok},q{</span>} );
      my $todo = ( $result->has_todo )
         ? ' # TODO '.$result->explanation
         : '';
      return "$ok[0] ".$result->number.q{ }.$result->description."$todo</span>";
   },
   comment => sub {
      my $result = shift;
      return q{<span class='comment'>}.$result->as_string.'</span>';
   },
   default => sub {
      my $result = shift;
      return q{<span class ='unknown'># }.$result->as_string.'</span>';
   }
};

method test($file) {
   my @total_results;
   my $tap_output = qx{perl $file 2>&1};
   my $parser = TAP::Parser->new( { tap => $tap_output } );
   while ( my $result = $parser->next ) {
      if (my $fn = $formatters->{ $result->type }) {
         push @total_results, $fn->( $result );
      } else {
         push @total_results, $formatters->{ default }->( $result );
      }
   }
   return \@total_results;
}

method tests {
   return join "\n", map {
      ( "<span class='file'>$_</span>", @{ $self->test( $_ ) } );
   } File::Find::Rule->file()->name('*.t')->maxdepth( 1 )
      ->in( File::Spec->catdir( $self->get_directory, 't' ) )
}

no Moose;
__PACKAGE__->meta->make_immutable;

