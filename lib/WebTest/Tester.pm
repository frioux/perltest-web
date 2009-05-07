package WebTest::Tester;
use Moose;
use feature ':5.10';

use File::Find::Rule;
use TAP::Parser;
use TAP::Parser::Aggregator;
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

   my @total_results;

   foreach my $file (@files) {
      push @total_results, "<span class='file'>$file</span>";
      my $tap_output = qx{perl $file 2>&1};
      warn $tap_output;
      my $parser = TAP::Parser->new( { tap => $tap_output } );
      RESULT:
      while ( my $result = $parser->next ) {
         given ( $result->type ) {
            when ( 'plan' ) {
               push @total_results, q{<span class='plan'>}.$result->plan.q{</span>};
            }
            when ( 'test' ) {
               my @ok = ( $result->is_ok )
                  ? ( q{<span class='passed-test'>ok},q{</span>} )
                  : ( q{<span class='failed-test'>not ok},q{</span>} );
               my $todo = ( $result->has_todo )
                  ? ' # TODO '.$result->explanation
                  : '';
               push @total_results, "$ok[0] ".$result->number.q{ }.$result->description."$todo</span>";
            }
            when ( 'comment' ) {
               push @total_results, q{<span class='comment'>}.$result->as_string.'</span>';
            }
            default {
               push @total_results, q{<span class ='unknown'># }.$result->as_string.'</span>';
            }
         }
      }
   }
   return join "\n", @total_results;
}

no Moose;
__PACKAGE__->meta->make_immutable;

