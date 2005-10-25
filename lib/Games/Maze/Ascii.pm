#  Ascii maze output
#  Performs transformation, cleanup, and printing of output of Games::Maze

package Games::Maze::Ascii;

use Games::Maze;

sub  new
 {
  my $obj = 
         {
          mazeparms => {},
         };

  bless $obj;
 }


sub  is_hex
 {
  my $self = shift;
  
  'Hex' eq ($self->{mazeparms}->{cell}||'');
 }


sub  toString
 {
  my $self = shift;
  my $maze = Games::Maze->new( %{$self->{mazeparms}} );
  $maze->make();
  $maze->to_ascii();
 }

sub  set_wall_form
 {
  my $self = shift;
  die "You can't change the form of an Ascii maze.\n";

  $self;
 }


sub  set_interactive
 {
  my $self = shift;
  die "Ascii mazes can't be interactive.\n";

  $self;
 }

1;
