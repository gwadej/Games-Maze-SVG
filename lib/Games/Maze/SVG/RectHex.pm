#  SVG maze output
#  Performs transformation, cleanup, and printing of output of Games::Maze

package Games::Maze::SVG::RectHex;

use base Games::Maze::SVG;

use Games::Maze;
use strict;

=head1 NAME

Games::Maze::SVG::RectHex - Build rectangular mazes with hexagonal cells in SVG.

=head1 VERSION

Version 0.1

=cut

our $VERSION = 0.1;

=head1 SYNOPSIS

Games::Maze::SVG::RectHex uses the Games::Maze module to create mazes in SVG.

    use Games::Maze::SVG;

    my $foo = Games::Maze::SVG->new( 'RectHex' );
    ...

=cut

use constant DELTA_X     => 10;
use constant DELTA_Y     => 10;
use constant SIGN_HEIGHT => 20;

# ----------------
#  Shape transformation tables
my %HexBlocks = (
                  ' '  => 0,
		  '_'  => 'xh',
		  '/'  => 'xsr',
		  '\\' => 'xsl',
                );

my %Walls = get_wall_forms();

my %crumbstyles = (
                   dash => "stroke-width:1; stroke-dasharray:5,3;",
                   dot  => "stroke-width:2; stroke-dasharray:2,6;",
                   line => "stroke-width:1;",
		   none => "visibility:hidden;",
                  );

=head1 FUNCTIONS

=cut

# ----------------------------------------------
#  Subroutines

=over 4

=item new

Create a new Games::Maze::SVG object. Supports the following named parameters:

Takes one positional parameter that is the maze type: Rect, RectHex, or Hex

=over 4

=item wallform

String naming the wall format. Legal values are bevel, round, roundcorners,
and straight.

=item crumb

String describing the breadcrumb design. Legal values are dash,
dot, line, and none

=item dx

The size of the tiles in the X direction.

=item dy

The size of the tiles in the Y direction.

=item dir

Directory in which to find the ecmascript for the maze interactivity. Should
either be relative, or in URL form.

=back

=cut

sub  new
{
    my $class = shift;
    
    my $shape = shift || 'Rect';
    my $obj = 
    {
    	Games::Maze::SVG::init_object(),
	@_,
    };

    $obj->{mazeparms}->{cell} = 'Hex';
    $obj->{mazeparms}->{form} = 'Rectangle';
    $obj->{scriptname} = "hexmaze.es";

    bless $obj;
}


=item is_hex

Method returns true.

=cut

sub  is_hex
{
    1;
}


=item is_hex_shaped

Method returns false.

=cut

sub  is_hex_shaped
{
    undef;
}


=item set_wall_form

Set the wall format for the current maze.

=over 4

=item $form

String specifying a wall format.

=back

Returns a reference to self for chaining.

=cut

sub  set_wall_form
{
    my $self = shift;
    my $form = shift;
  
    if(exists $Walls{$form})
    {
        $self->{wallform} = $form;
    }
    else
    {
        my $forms = join( ", ", sort keys %Walls );
        die "\n'$form' is not a valid wall form.\nTry one of: $forms\n\n";
    }
    $self;
}


=item make_board_array

Build a two-dimensional array of integers that maps the board from
the two dimensional matrix of wall descriptions.

=cut

sub make_board_array
{
    my $self = shift;
    my $rows = shift;
    my @board = ();

    foreach my $row (@{$rows})
    {
        push @board, [ map { $_ ? ($_ eq 'xh' ? -1 : 1) : 0 } @{$row} ];
    }
    
    \@board;
}


#
# Generates just the maze portion of the SVG.
#
# $dx - The size of the tiles in the X direction.
# $dy - The size of the tiles in the Y direction.
# $rows - Reference to an array of row data.
#
# returns a string containing the SVG for the maze description.
sub  _just_maze
 {
  my $dx   = shift;
  my $dy   = shift;
  my $rows = shift;

  my $output = '';
  my ($maxx,$y) = (0,0);

  foreach my $r (@{$rows})
   {
    my $x = 0;
    foreach my $c (@{$r})
     {
      $output .= qq{  <use x="$x" y="$y" xlink:href="#$c"/>\n} if $c;
      $x += $dx;
     }
    $y += $dy;
    $maxx = $x if $maxx < $x;
   }

  { width=>$maxx, height=>$y, maze=>$output };
 }


=item transform_grid

Convert the hexagonal grid from ascii format to SVG definition
 references.

=over 4

=item $rows

Reference to an array of rows

=item $walls

String specifying wall format. (Unused at present.)

=back

=cut

sub transform_grid
{
    my $self = shift;
    my $rows = shift;
    my @out  = ();

    # transform the printout into block commands
    my $height = @{$rows};
    my $width  = @{$rows->[0]}+1;
    for(my $r=0; $r < $height; ++$r)
    {
	for(my $c=0; $c < $width; ++$c)
        {
	    if(defined $rows->[$r]->[$c])
	    {
        	die "Missing block for '$rows->[$r]->[$c]'.\n"
	                	    unless exists $HexBlocks{$rows->[$r]->[$c]};
        	$out[$r]->[$c] = $HexBlocks{$rows->[$r]->[$c]};
	    }
	    else
	    {
        	$out[$r]->[$c] = 0;
	    }
        }
    }
    @{$rows} = @out;
}


=item wall_definitions

Method that returns the definition for the shaps used to build the walls.

=cut

sub wall_definitions
{
    my $self = shift;

    $Walls{$self->{wallform}}
}

=item get_wall_forms

Extract the wall forms from the DATA file handle.

Returns a hash of wall forms.

=cut

sub get_wall_forms
{
 local $/ = "\n===\n";
 chomp( my @list = <DATA> );
 @list;
}

=back

=head1 AUTHOR

G. Wade Johnson, C<< <wade@anomaly.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-maze-svg1@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Maze-SVG1>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

Thanks go to Valen Johnson and Jason Wood for extensive test play of the
mazes.

=head1 COPYRIGHT & LICENSE

Copyright 2004-2005 G. Wade Johnson, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;


__DATA__
straight
===
    <path id="ul" d="M5,10 v-5 h5"/>
    <path id="ur" d="M0,5  h5  v5"/>
    <path id="ll" d="M5,0  v5  h5"/>
    <path id="lr" d="M0,5  h5  v-5"/>
    <path id="h"  d="M0,5  h10"/>
    <path id="v"  d="M5,0  v10"/>
    <path id="l"  d="M0,5  h5"/>
    <path id="r"  d="M5,5  h5"/>
    <path id="t"  d="M5,0  v5"/>
    <path id="d"  d="M5,5  v5"/>
    <path id="tr" d="M5,0  v10 M5,5 h5"/>
    <path id="tl" d="M5,0  v10 M0,5 h5"/>
    <path id="tu" d="M0,5  h10 M5,0 v5"/>
    <path id="td" d="M0,5  h10 M5,5 v5"/>
    <path id="cross" d="M0,5 h10 M5,0 v10"/>
    <path id="xh"  d="M0,10 h5"/>
    <path id="xsr" d="M0,10 l5,-10"/>
    <path id="xsl" d="M0,0  l5,10"/>
===
roundcorners
===
    <path id="ul" d="M5,10 Q5,5 10,5"/>
    <path id="ur" d="M0,5  Q5,5 5,10"/>
    <path id="ll" d="M5,0  Q5,5 10,5"/>
    <path id="lr" d="M0,5  Q5,5 5,0"/>
    <path id="h"  d="M0,5  h10"/>
    <path id="v"  d="M5,0  v10"/>
    <path id="l"  d="M0,5  h5"/>
    <path id="r"  d="M5,5  h5"/>
    <path id="t"  d="M5,0  v5"/>
    <path id="d"  d="M5,5  v5"/>
    <path id="tr" d="M5,0  v10 M5,5 h5"/>
    <path id="tl" d="M5,0  v10 M0,5 h5"/>
    <path id="tu" d="M0,5  h10 M5,0 v5"/>
    <path id="td" d="M0,5  h10 M5,5 v5"/>
    <path id="cross" d="M0,5 h10 M5,0 v10"/>
===
round
===
    <path id="ul" d="M5,10 Q5,5 10,5"/>
    <path id="ur" d="M0,5  Q5,5 5,10"/>
    <path id="ll" d="M5,0  Q5,5 10,5"/>
    <path id="lr" d="M0,5  Q5,5 5,0"/>
    <path id="h"  d="M0,5  h10"/>
    <path id="v"  d="M5,0  v10"/>
    <path id="l"  d="M0,5  h5"/>
    <path id="r"  d="M5,5  h5"/>
    <path id="t"  d="M5,0  v5"/>
    <path id="d"  d="M5,5  v5"/>
    <path id="tr" d="M5,0  Q5,5 10,5 Q5,5 5,10"/>
    <path id="tl" d="M5,0  Q5,5 0,5  Q5,5 5,10"/>
    <path id="tu" d="M0,5  Q5,5 5,0  Q5,5 10,5"/>
    <path id="td" d="M0,5  Q5,5 5,10 Q5,5 10,5"/>
    <path id="cross"
                  d="M0,5 Q5,5 5,0  Q5,5 10,5 Q5,5 5,10 Q5,5 0,5"/>
===
bevel
===
    <path id="ul" d="M5,10.1 v-.1 l5,-5 h.1"/>
    <path id="ur" d="M-.1,5 h.1 l5,5 v.1"/>
    <path id="ll" d="M5,-.1 v.1 l5,5 h.1"/>
    <path id="lr" d="M-.1,5 h.1 l5,-5 v-.1"/>
    <path id="h"  d="M0,5  h10"/>
    <path id="v"  d="M5,0  v10"/>
    <path id="l"  d="M0,5  h5"/>
    <path id="r"  d="M5,5  h5"/>
    <path id="t"  d="M5,0  v5"/>
    <path id="d"  d="M5,5  v5"/>
    <polygon id="tr" points="5,0 5,10 10,5"/>
    <polygon id="tl" points="5,0 5,10 0,5"/>
    <polygon id="tu" points="0,5 10,5 5,0"/>
    <polygon id="td" points="0,5 10,5 5,10"/>
    <polygon id="cross" points="0,5 5,10 10,5 5,0"/>
    <path id="oul" d="M5,10.1 v-.1 l5,-5 h.1"/>
    <path id="our" d="M-.1,5 h.1 l5,5 v.1"/>
    <path id="oll" d="M5,-.1 v.1 l5,5 h.1"/>
    <path id="olr" d="M-.1,5 h.1 l5,-5 v-.1"/>
    <path id="oh"  d="M0,5  h10"/>
    <path id="ov"  d="M5,0  v10"/>
    <path id="ol"  d="M0,5  h5"/>
    <path id="or"  d="M5,5  h5"/>
    <path id="ot"  d="M5,0  v5"/>
    <path id="od"  d="M5,5  v5"/>
    <path id="otr" d="M5,0 l5,5 l-5,5"/>
    <path id="otl" d="M5,0 l-5,5 l5,5"/>
    <path id="otu" d="M0,5 l5,-5 l5,5"/>
    <path id="otd" d="M0,5 l5,5 l5,-5"/>