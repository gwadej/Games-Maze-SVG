#  SVG maze output
#  Handles the common code between Hex and RectHex mazes.

package Games::Maze::SVG::HexCells;

use base Games::Maze::SVG;

use Carp;
use Games::Maze;
use strict;

=head1 NAME

Games::Maze::SVG::HexCells - Base class for Hex and RectHex mazes.

=head1 VERSION

Version 0.4

=cut

our $VERSION = 0.4;

=head1 SYNOPSIS

The class is intended to only be used as a base class. It should not
instatiated directly.

=cut

use constant DELTA_X     => 10;
use constant DELTA_Y     => 10;

my $bVerbose = 0;

# ----------------
#  Shape transformation tables

# in-line
# l r dl dr
my %Blocks = (
    '   /' => 0,
    ' _/ ' => 'tl',
    '__  ' => 'hz',
    '_  \\' => 'tr',
    '  \\ ' => 0,

    ' / \\' => 'cl',
    '/ \\_' => 0,
    '  __' => 0,
    ' \\_/' => 0,
    '\\ / ' => 'cr',

    ' \\  ' => 0,
    '\\_  ' => 'bl',
    '_/  ' => 'br',
    '/   ' => 0,

    '  \\_' => 0,
    '  _/' => 0,
    '    ' => 0,

    '/ \\ ' => 0,
    ' \\ /' => 0,
    '\\_/ ' => 'yr',
    '/  _' => 0,
    ' \\_ ' => 0,
    '\\   ' => 'slb',
    '   \\'=> 'slt',

    '_   ' => 'hzl',
    '   _' => 0,

    '  _ ' => 0,
    ' _  ' => 'hzr',
    '_/ \\' => 'yl',

    ' /  ' => 'srb',
    '/   ' => 0,
    
    '  / ' => 'srt',
);

# Between lines
# l r dl dr
my %BlocksBetween = (
    '   /' => 'sr',
    ' _/ ' => '$',
    '__  ' => 0,
    '_  \\' => 'sl',
    '  \\ ' => '$',

    ' / \\' => 'sl',
    '/ \\_' => '$',
    '  __' => 0,
    ' \\_/' => 'sr',
    '\\ / ' => '$',

    '  \\_' => '$',
    '  _/' => 'sr',
    '    ' => 0,

    '/ \\ ' => '$',
    ' \\ /' => 'sr',
    '\\_/ ' => '$',
    '_/  ' => 0,
    '/  _' => 0,
    ' \\_ ' => 0,
    '\\   ' => 0,
    '   \\' => 'sl',

    '_   ' => 0,
    '   _' => 0,

    '  _ ' => 0,
    ' _  ' => 0,
    '_/ \\' => 'sl',

    '\\_  ' => 0,
    ' \\  ' => 0,
    
    '  / ' => 0,
    '/   ' => 0,
    ' /  ' => 0,
);

my %Walls = _get_wall_forms();

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

    my $obj = 
    {
    	Games::Maze::SVG::init_object( @_ ),
	@_,
    };

    if(!exists $Walls{$obj->{wallform}})
    {
        my $forms = join( ", ", sort keys %Walls );
        croak "\n'$obj->{wallform}' is not a valid wall form.\nTry one of: $forms\n\n";
    }

    $obj->{mazeparms}->{cell} = 'Hex';
    $obj->{scriptname} = "hexmaze.es";
    $obj->{dx} = DELTA_X;
    $obj->{dy} = DELTA_Y;

    bless $obj;
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
        croak "\n'$form' is not a valid wall form.\nTry one of: $forms\n\n";
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
    my $walls = shift;
    my @out  = ();

    # transform the printout into block commands
    my $height = @{$rows};
    my $width  = @{$rows->[0]}+2;
    
    for(my $r=0; $r < $height-1; ++$r)
    {
	# on line
        push @out, _calc_on_line( $rows, $r, $width );
	# between
        push @out, _calc_between_line( $rows, $r, $width );
    }
    push @out, _calc_on_line( $rows, $height-1, $width );

    @{$rows} = @out;
}


sub _calc_between_line
{
    my $rows = shift;
    my $index = shift;
    my $width = shift;
    my @out = ();
    
    for(my $c = 0; $c < $width;++$c)
    {
        my $sig = ($c ? $rows->[$index][$c-1]||' ' : ' ')
	        . ($rows->[$index][$c]||' ')
	        . ($c ? $rows->[$index+1][$c-1]||' ' : ' ')
		. ($rows->[$index+1][$c]||' ');

print "b($index, $c) = '$sig'\n" if $bVerbose;
        croak "Missing between block for '$sig'.\n" unless exists $BlocksBetween{$sig};

        push @out, $BlocksBetween{$sig};
    }
    
    \@out;
}


sub _calc_on_line
{
    my $rows = shift;
    my $index = shift;
    my $width = shift;
    my @out = ();
    
    for(my $c = 0; $c < $width;++$c)
    {
        my $sig = ($c ? $rows->[$index][$c-1]||' ' : ' ')
	        . ($rows->[$index][$c]||' ')
	        . ($c ? $rows->[$index+1][$c-1]||' ' : ' ')
		. ($rows->[$index+1][$c]||' ');

print "o($index, $c) = '$sig'\n" if $bVerbose;
        croak "Missing block for '$sig'.\n" unless exists $Blocks{$sig};

        push @out, $Blocks{$sig};
    }

    \@out;
}

=begin COMMENT

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
        	croak "Missing block for '$rows->[$r]->[$c]'.\n"
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

=cut

=item wall_definitions

Method that returns the definition for the shapes used to build the walls.

=cut

sub wall_definitions
{
    my $self = shift;

    $Walls{$self->{wallform}}
}

# _get_wall_forms
#
#Extract the wall forms from the DATA file handle.
#
#Returns a hash of wall forms.

sub _get_wall_forms
{
 local $/ = "\n===\n";
 chomp( my @list = <DATA> );
 @list;
}


=item convert_start_position

Convert the supplied x and y coordinates into the appropriate real coordinates
for a start position on this map.

=over 4

=item $x x coord from the maze

=item $y y coord from the maze

=back

returns a two element list containing (x, y).

=cut

sub convert_start_position
{
    my $self = shift;
    my ($x, $y) = @_;

    $x = 3*($x-1)+2;
    $y = 4*($y-1);

    ($x, $y);
}

=item convert_end_position

Convert the supplied x and y coordinates into the appropriate real coordinates
for a end position on this map.

=over 4

=item $x x coord from the maze

=item $y y coord from the maze

=back

returns a two element list containing (x, y).

=cut

sub convert_end_position
{
    my $self = shift;
    my ($x, $y) = @_;

    $x = 3*($x-1)+2;
    $y = 4*($y)+2;

    ($x, $y);
}

=back

=head1 AUTHOR

G. Wade Johnson, C<< <wade@anomaly.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-maze-svg1@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Game-Maze-SVG>.
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
      <path id="hz" d="M0,5 h10"/>
      <path id="hzr" d="M5,5 h5"/>
      <path id="hzl" d="M0,5 h5"/>
      <path id="tl" d="M10,5 h-5 L2.5,10"/>
      <path id="tr" d="M0,5 h5 L10,15"/>
      <path id="br" d="M0,5 h5 L10,-5"/>
      <path id="bl" d="M10,5 h-5 L0,-5"/>
      <path id="sl" d="M7.5,0 L12.5,10"/>
      <path id="sr" d="M12.5,0 L7.5,10"/>
      <path id="slt" d="M5,5 L7.5,10"/>
      <path id="slb" d="M5,5 L2.5,0"/>
      <path id="srt" d="M5,5 L2.5,10"/>
      <path id="srb" d="M5,5 L7.5,0"/>
      <path id="cr" d="M2.5,0 L5,5 L2.5,10"/>
      <path id="cl" d="M7.5,0 L5,5 L7.5,10"/>
      <path id="yr" d="M2.5,0 L5,5 L2.5,10 M5,5 h5"/>
      <path id="yl" d="M7.5,0 L5,5 L7.5,10 M5,5 h-5"/>
      <path id="zz" d="M7.5,0 L2.5,10 M2.5,0 L7.5,10"/>
