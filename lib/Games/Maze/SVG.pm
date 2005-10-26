#  SVG maze output
#  Performs transformation, cleanup, and printing of output of Games::Maze

package Games::Maze::SVG;

use Games::Maze;
use strict;

=head1 NAME

Games::Maze::SVG - Build mazes in SVG.

=head1 VERSION

Version 0.5

=cut

our $VERSION = 0.5;

=head1 SYNOPSIS

Games::Maze::SVG uses the Games::Maze module to create mazes in SVG.

    use Games::Maze::SVG;

    my $foo = Games::Maze::SVG->new();
    ...

=cut

use constant DELTA_X     => 10;
use constant DELTA_Y     => 10;
use constant SIGN_HEIGHT => 20;

# ----------------
#  Shape transformation tables
my %Blocks = ( ': - |' => 'ul',  ':-  |' => 'ur',
	       ': -| ' => 'll',  ':- | ' => 'lr',
               ':--  ' => 'h',   '-::  ' => 'h',
               ':  ||' => 'v',   '|  ::' => 'v',
               ':-   ' => 'l',   ': -  ' => 'r',
               ':  | ' => 't',   ':   |' => 'd',
	       ': -||' => 'tr',  ':- ||' => 'tl',
	       ':--| ' => 'tu',  ':-- |' => 'td',
	       ':--||' => 'cross',
	       ':.- |' => 'oul', ':- .|' => 'our',
	       ': -.|' => 'oul', ':-. |' => 'our',
	       ':.-.|' => 'oul', ':-..|' => 'our',
	       ':.-| ' => 'oll', ':-.| ' => 'olr',
	       ': -|.' => 'oll', ':- |.' => 'olr',
	       ':.-|.' => 'oll', ':-.|.' => 'olr',
               ':--. ' => 'oh',  '-::. ' => 'oh',
               ':-- .' => 'oh',  '-:: .' => 'oh',
               ':. ||' => 'ov',  '|. ::' => 'ov',
               ': .||' => 'ov',  '| .::' => 'ov',
               ':- . ' => 'ol',  ': -. ' => 'or',
               ':-.  ' => 'ol',  ':.-  ' => 'or',
               ':-  .' => 'ol',  ': - .' => 'or',
               ':. | ' => 'ot',  ':.  |' => 'od',
               ': .| ' => 'ot',  ': . |' => 'od',
               ':  |.' => 'ot',  ':  .|' => 'od',
               ':. |.' => 'ot',  ':. .|' => 'od',
               ': .|.' => 'ot',  ': ..|' => 'od',
	       ':.-||' => 'otr', ':-.||' => 'otl',
	       ':--|.' => 'otu', ':--.|' => 'otd',
             );
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
  my $obj = 
         {
          mazeparms => {},
	  wallform  => 'round',
	  crumb     => 'dash',
	  dx        => DELTA_X,
	  dy        => DELTA_Y,
	  dir       => '',
	  @_,
         };

  bless $obj;
 }


=item is_hex

Method returns true if the maze is made of hexagonal cells.

=cut

sub  is_hex
 {
  my $self = shift;
  
  'Hex' eq ($self->{mazeparms}->{cell}||'');
 }


=item is_hex_shaped

Method returns true if the overall shape of the maze is a hexagon.

=cut

sub  is_hex_shaped
 {
  my $self = shift;
  
  'Hex' eq ($self->{mazeparms}->{shape}||'');
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


=item set_interactive

Method makes the maze interactive.

Returns a reference to self for chaining.

=cut

sub  set_interactive
 {
  my $self = shift;
  $self->{interactive} = 1;
  $self;
 }


=item set_crumbstyle

=over 4

=item $bcs

String specifying the breadcrumb style. Generates an exception if the
breadcrumb style is not recognized.

Returns a reference to self for chaining.

=back

=cut

sub  set_crumbstyle
 {
  my $self = shift;
  my $bcs  = shift;

  return unless defined $bcs;

  die "Unrecognized breadcrumb style '$bcs'.\n" unless exists $crumbstyles{$bcs};
  $self->{crumb} = $bcs;
  $self;
 }


=item toString

Method that converts the current maze into an SVG string.

=cut

sub  toString
 {
  my $self = shift;
  my $maze = Games::Maze->new( %{$self->{mazeparms}} );

  $self->set_wall_form( 'straight' ) if $self->is_hex();

  my $output = '';
  $maze->make();
  my @rows = map { [ split //, $_ ] }
                 split( /\n/, $maze->to_ascii() );

  my ($dx2, $dy2) = ($self->{dx}/2, $self->{dy}/2);
  my $scriptname = '';
  my $script = '';
  my $sprite = '';
  my $crumb  = '';
  my $color  = {
                mazebg => '#ffc', # '#9cc'; # '#fc0'
                panel  => '#ccc',
                crumb  => '#f3f',
                sprite => 'orange',
		button => '#ccf',
               };

  my $crumbstyle = $crumbstyles{$self->{crumb}};
  my $mazeout;
  my ($xp, $yp, $xe, $ye, $xsign, $ysign);

  if($self->is_hex())
   {
    $self->{dx}  /= 2;
    $dx2          = $self->{dx}/2;

    transform_hex_grid( \@rows );
    $mazeout = _just_maze( $self->{dx}, $self->{dy}, \@rows );

    $scriptname = 'hexmaze';
    ($xp, $yp) = (3*($maze->{entry}->[0]-1)+2, 2*($maze->{entry}->[1]-1) );
    ($xe, $ye) = (3*($maze->{exit}->[0]-1)+2, 2*($maze->{exit}->[1])+1 );
    if($self->is_hex_shaped())
    {
        ($xsign, $ysign) = (($xe+1)*$self->{dx},($ye+3)*$self->{dy});
    }
    else
    {
        ($xsign, $ysign) = ($xe*$self->{dx},($ye+2)*$self->{dy});
    }
   }
  else
   {
    transform_rect_grid( \@rows, $self->{wallform} );
    $mazeout = _just_maze( $self->{dx}, $self->{dy}, \@rows );

    $scriptname = 'rectmaze';
    ($xp, $yp) = (2*($maze->{entry}->[0]-1)+1, 2*($maze->{entry}->[1]-1) );
    ($xe, $ye) = (2*($maze->{exit}->[0]-1)+1, 2*($maze->{exit}->[1]) );
    ($xsign, $ysign) = (($xe+0.5)*$self->{dx},($ye+2)*$self->{dy});
   }

  my $totalwidth = $mazeout->{width};
  my $ht         = $mazeout->{height} + SIGN_HEIGHT;
  my $panelwidth = 250;
  my $background =
      qq{  <rect id="mazebg" x="0" y="0" width="$mazeout->{width}" height="$ht"/>\n};
  my $load = '';

  if($self->{interactive})
   {
    $script  = qq{    <script language="ecmascript" xlink:href="$self->{dir}$scriptname.es"/>\n};
    $script .= qq{    <script language="ecmascript">\n}
              .qq{      var board = new Array();\n};
    my $i = 0;
    foreach my $row (@rows)
     {
      $script .= qq{      board[$i] = new Array(}
                 . join( ', ', map { $_ ? ($_ eq 'xh' ? -1 : 1) : 0 } @{$row} )
	         . qq{ );\n};
      $i++;
     }
    $script .= qq{    </script>\n};

    $sprite = qq{  <use id="me" x="0" y="0" xlink:href="#sprite" visibility="hidden"/>\n};
    $crumb = qq{  <polyline id="crumb" points="0,0"/>};

    $background = <<"EOB";
  <rect id="mazebg" x="0" y="0" width="$mazeout->{width}" height="$ht"/>
EOB
    $totalwidth += $panelwidth;
    $load = qq[\n     onload="initialize( board, {x:$xp, y:$yp}, {x:$xe, y:$ye}, {x:$self->{dx}, y:$self->{dy}} )"];
   }

  $output .= <<"EOH";
<?xml version="1.0"?>
<svg width="$totalwidth" height="$ht"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"$load
     onkeydown="move_sprite(evt)" onkeyup="unshift(evt)">
  <metadata>
    <!--
        Copyright 2004-2005, G. Wade Johnson
	Some rights reserved.
    -->
    <rdf:RDF xmlns="http://web.resource.org/cc/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <Work rdf:about="">
       <dc:title>SVG Maze</dc:title>
       <dc:date>2005</dc:date>
       <dc:description>An SVG-based Game</dc:description>
       <dc:creator><Agent>
	  <dc:title>G. Wade Johnson</dc:title>
       </Agent></dc:creator>
       <dc:rights><Agent>
	  <dc:title>G. Wade Johnson</dc:title>
       </Agent></dc:rights>
       <dc:type rdf:resource="http://purl.org/dc/dcmitype/Interactive" />
       <license rdf:resource="http://creativecommons.org/licenses/by-sa/2.0/" />
    </Work>

    <License rdf:about="http://creativecommons.org/licenses/by-sa/2.0/">
       <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
       <permits rdf:resource="http://web.resource.org/cc/Distribution" />
       <requires rdf:resource="http://web.resource.org/cc/Notice" />
       <requires rdf:resource="http://web.resource.org/cc/Attribution" />
       <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
       <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
    </License>

    </rdf:RDF>
  </metadata>
  <defs>
    <style type="text/css">
      path    { stroke: black; fill: none; }
      polygon { stroke: black; fill: grey; }
      #sprite { stroke: grey; stroke-width:0.2; fill: $color->{sprite}; }
      #crumb  { fill:none; stroke:$color->{crumb}; $crumbstyle; }
      #mazebg { fill:$color->{mazebg}; stroke:none; }
      .panel  { fill:$color->{panel}; stroke:none; }
      .button {
                 cursor: pointer;
              }
      text { font-family: sans-serif; }
      rect.button { fill: #33f; stroke: none; filter: url(#bevel);
                  }
      text.button { text-anchor:middle; fill:#fff; font-weight:bold; }
      .sign text {  fill:#fff;text-anchor:middle; font-weight:bold; }
      .sign rect {  fill:red; stroke:none; }
      #solvedmsg { text-anchor:middle; pointer-events:none; font-size:80; fill:red;
                 }
    </style>
     <filter id="bevel">
       <feFlood flood-color="#ccf" result="lite-flood"/>
       <feFlood flood-color="#006" result="dark-flood"/>
       <feComposite operator="in" in="lite-flood" in2="SourceAlpha"
                    result="lighter"/>
       <feOffset in="lighter" result="lightedge" dx="-1" dy="-1"/>
       <feComposite operator="in" in="dark-flood" in2="SourceAlpha"
                    result="darker"/>
       <feOffset in="darker" result="darkedge" dx="1" dy="1"/>
       <feMerge>
         <feMergeNode in="lightedge"/>
         <feMergeNode in="darkedge"/>
         <feMergeNode in="SourceGraphic"/>
        </feMerge>
     </filter>
    <path id="sprite" d="M0,0 Q$dx2,$dy2 0,$self->{dy} Q$dx2,$dy2 $self->{dx},$self->{dy} Q$dx2,$dy2 $self->{dx},0 Q$dx2,$dy2 0,0"/>
$Walls{$self->{wallform}}
$script
    <script type="text/ecmascript">
      function push( evt )
       {
        var btn = evt.getCurrentTarget();
	btn.setAttributeNS( null, "opacity", "0.5" );
       }
      function release( evt )
       {
        var btn = evt.getCurrentTarget();
	if("" != btn.getAttributeNS( null, "opacity" ))
           btn.removeAttributeNS( null, "opacity" );
       }
    </script>
  </defs>
$background
$mazeout->{maze}
$crumb
$sprite
EOH

  if($self->{interactive})
   {
    my $xrect = $mazeout->{width} + 20;
    my ($cx,$cy) = ($mazeout->{width}/2, (35+$mazeout->{height}/2));
    $output .= <<"EOB";
  <rect x="$mazeout->{width}" y="0" width="$panelwidth" height="$ht"
        class="panel"/>

  <g onclick="restart()" transform="translate($xrect,20)"
     onmousedown="push(evt)" onmouseup="release(evt)" onmouseout="release(evt)">
    <rect x="0" y="0" width="50" height="20" rx="5" ry="5"
          class="button"/>
    <text x="25" y="15" class="button">Begin</text>
  </g>
  
  <g class="instruct" transform="translate($xrect,70)">
    <text x="0" y="0">Click Begin button to start</text>
    <text x="0" y="30">Use the arrow keys to move the sprite</text>
    <text x="0" y="50">Hold the shift to move quickly.</text>
    <text x="0" y="80">The mouse must remain over the</text>
    <text x="0" y="100">maze for the keys to work.</text>
  </g>
  <g transform="translate($xsign,$ysign)" class="sign">
    <rect x="-16" y="-8" width="32" height="16" rx="3" ry="3"/>
    <text x="0" y="4">Exit</text>
  </g>
  <text id="solvedmsg" x="$cx" y="$cy" opacity="1.0">Solved!</text>
EOB
   }
  $output . "\n</svg>\n";
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


=item transform_rect_grid

Convert the rectangular grid from ascii format to SVG definition
   references.

=over 4

=item $rows

Reference to an array of rows

=item $walls

String specifying wall format.

=back

=cut

sub  transform_rect_grid
 {
  my $rows  = shift;
  my $walls = shift;
  my @out  = ();

  my $sp = 'bevel' eq ($walls||'') ? '.' : ' ';
  remove_horiz_padding( $rows );

  # transform the printout into block commands
  my $height = @{$rows};
  my $width  = @{$rows->[0]};
  for(my $r=0; $r < $height; ++$r)
   {
    for(my $c=0; $c < $width; ++$c)
     {
      if($rows->[$r]->[$c] eq ' ')
       {
        $out[$r]->[$c] = 0;
       }
      else
       {
        # convert the cell and its neighbors into a signature
        my $sig = $rows->[$r]->[$c]                   # cell
	        . ($c==0 ? $sp : $rows->[$r]->[$c-1]) # left neighbor
	        . ($rows->[$r]->[$c+1] || $sp)        # right neighbor
		. ($r==0 ? $sp : $rows->[$r-1]->[$c]) # up neighbor
	        . ($rows->[$r+1] ? $rows->[$r+1]->[$c] : $sp); # down neighbor
	# convert the signature into the block name
	die "Missing block for '$sig'.\n" unless exists $Blocks{$sig};
	$out[$r]->[$c] = $Blocks{$sig};
       }
     }
   }
  @{$rows} = @out;
 }


=item transform_hex_grid

Convert the hexagonal grid from ascii format to SVG definition
 references.

=over 4

=item $rows

Reference to an array of rows

=back

=cut

sub transform_hex_grid
 {
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


=item remove_horiz_padding

Remove the extra horizontal space inserted to regularize the look
 of the rectangular maze

=over 4

=item $rows

Reference to an array of rows

=back

=cut

sub  remove_horiz_padding
 {
  my $rows = shift;
  for(my $i = $#{$rows->[0]}; $i > 0; $i -= 3)
   {
    splice( @{$_}, $i-1, 1 ) foreach(@{$rows});
   }

  # apparently trailing spaces that I wasn't aware of.
  foreach my $r (@{$rows})
   {
    pop @{$r} if $r->[-1] eq ' ';
   }
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
