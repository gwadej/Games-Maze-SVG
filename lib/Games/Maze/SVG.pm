#  SVG maze output
#  Performs transformation, cleanup, and printing of output of Games::Maze

package Games::Maze::SVG;

use Carp;
use Games::Maze;
use Games::Maze::SVG::Rect;
use Games::Maze::SVG::RectHex;
use Games::Maze::SVG::Hex;

use strict;

=head1 NAME

Games::Maze::SVG - Build mazes in SVG.

=head1 VERSION

Version 0.71

=cut

our $VERSION = 0.71;

=head1 SYNOPSIS

Games::Maze::SVG uses the Games::Maze module to create mazes in SVG.

    use Games::Maze::SVG;

    my $foo = Games::Maze::SVG->new();
    ...

See Games::Maze::SVG::Manual for more information on using the module.

=cut

use constant SIGN_HEIGHT => 20;
use constant SIDE_MARGIN => 10;
use constant PANEL_WIDTH => 250;

my %crumbstyles = (
                   dash => "stroke-width:1px; stroke-dasharray:5px,3px;",
                   dot  => "stroke-width:2px; stroke-dasharray:2px,6px;",
                   line => "stroke-width:1px;",
		   none => "visibility:hidden;",
                  );

my $license = <<'EOL';
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
EOL

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

=item dir

Directory in which to find the ecmascript for the maze interactivity. Should
either be relative, or in URL form.

=item interactive

This parameter determines if the maze will be interactive. If the value of the
parameter is true (1), the appropriate scripting and support is written into
the SVG. If the parameter is omitted or false, no interactive support is
provided.

=item cols

The number of columns used in creating the maze. Default value is 12.

=item rows

The number of rows used in creating the maze. Default value is 12.

=item startcol

The column where the entry is found. Default value is random.

=item endcol

The column where the exit is found. Default value is random.

=back

=cut

sub  new
{
    my $class = shift;
    
    my $shape = shift || 'Rect';
    
    my %params = @_;
    
    if(exists $params{crumb} and !exists $crumbstyles{$params{crumb}})
    {
        croak "Unrecognized breadcrumb style '$params{crumb}'.\n"
    }

    return Games::Maze::SVG::Rect->new( @_ )    if 'Rect' eq $shape;
    return Games::Maze::SVG::RectHex->new( @_ ) if 'RectHex' eq $shape;
    return Games::Maze::SVG::Hex->new( @_ )     if 'Hex' eq $shape;

    croak "Unrecognized maze shape '$shape'.\n";
}


=item init_object

Initializes the maze object with the default values for all mazes. The derived
classes should call this method in their constructors.

Returns the initial data members as a list.

=cut

sub init_object
{
    my %parms = @_;

    my %obj =
    (
        mazeparms => {},
	wallform  => 'straight',
	crumb     => 'dash',
	dir       => 'scripts/',
    );
    $obj{mazeparms}->{dimensions} = [ $parms{cols}||12, $parms{rows}||12, 1 ];
    $obj{mazeparms}->{entry} = [ $parms{startcol}, 1, 1 ] if $parms{startcol};
    
    if($parms{endcol})
    {
        $obj{mazeparms}->{exit} = [
            $parms{endcol}, $obj{mazeparms}->{dimensions}->[1], 1
        ];
    }

    %obj;
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


=item set_breadcrumb

=over 4

=item $bcs

String specifying the breadcrumb style. Generates an exception if the
breadcrumb style is not recognized.

=back

Returns a reference to self for chaining.

=cut

sub  set_breadcrumb
{
    my $self = shift;
    my $bcs  = shift;

    return unless defined $bcs;

    croak "Unrecognized breadcrumb style '$bcs'.\n"
      unless exists $crumbstyles{$bcs};
    $self->{crumb} = $bcs;
    $self->{crumbstyle} = $crumbstyles{$bcs};

    $self;
}


=item get_crumbstyle

Returns the CSS style for the breadcrumb.

=cut

sub  get_crumbstyle
{
    my $self = shift;

    $self->{crumbstyle} ||= $crumbstyles{$self->{crumb}};
}


=item get_script

Method that returns the path to the interactivity script.

=cut

sub get_script
{
    my $self = shift;
    
    "$self->{dir}$self->{scriptname}";
}

=item toString

Method that converts the current maze into an SVG string.

=cut

sub  toString
{
    my $self = shift;
    my $maze = Games::Maze->new( %{$self->{mazeparms}} );

    $maze->make();
    my @rows = map { [ split //, $_ ] }
                   split( /\n/, $maze->to_ascii() );

    my $crumb  = '';
    my $color  = {
                  mazebg => '#ffc', # '#9cc'; # '#fc0'
                  panel  => '#ccc',
                  crumb  => '#f3f',
                  sprite => 'orange',
		  button => '#ccf',
        	 };

    my $crumbstyle = $self->get_crumbstyle();

    $self->transform_grid( \@rows, $self->{wallform} );
    $self->_just_maze( \@rows );

    my ($xp, $yp) = $self->convert_start_position( @{$maze->{entry}} );
    my ($xe, $ye) = $self->convert_end_position( @{$maze->{exit}} );
    my ($xenter, $yenter) = $self->convert_sign_position( $xp, $yp );
    my ($xexit, $yexit) = $self->convert_sign_position( $xe, $ye );

    my $width = $self->{width} + 2 * SIDE_MARGIN;
    my $height = $self->{height} + 2 * SIGN_HEIGHT;
    my ($cx,$cy) = ($self->{width}/2, (35+$self->{height}/2));
    my $sprite_def = $self->create_sprite();

    my $output = qq{<?xml version="1.0"?>\n} ;
    my $offsety = - SIGN_HEIGHT;
    my $offsetx = - SIDE_MARGIN;
    my ($xme, $yme) = ($xp*$self->dx(), $yp*$self->dy());
    my ($xcrumb, $ycrumb) = ($xme+$self->dx()/2, $yme+$self->dy()/2);

    if($self->{interactive})
    {
        my $script = $self->build_all_script( \@rows );

        my $totalwidth = $width + PANEL_WIDTH;
        $output .= <<"EOH";
<svg width="$totalwidth" height="$height"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     onload="initialize( board, {x:$xp, y:$yp}, {x:$xe, y:$ye}, {x:@{[$self->dx()]}, y:@{[$self->dy()]}} )"
     onkeydown="move_sprite(evt)" onkeyup="unshift(evt)">
$license
  <defs>
     <style type="text/css">
	text { font-family: sans-serif; }
	.panel  { fill:$color->{panel}; stroke:none; }
	.button {
                   cursor: pointer;
        	}
	.button rect { fill: #33f; stroke: none; filter: url(#bevel);
                    }
	.button text { text-anchor:middle; fill:#fff; font-weight:bold; }
	.button polygon { fill:white; stroke:none; }
	.ctrllabel { text-anchor:middle; font-weight:bold; }
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
$script
  </defs>
  <svg x="@{[ PANEL_WIDTH ]}" y="0" width="$width" height="$height"
       viewBox="$offsetx $offsety $width $height" id="maze">
EOH
    }
    else
    {
        $output .= <<"EOH";
<svg width="$width" height="$height"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
$license
  <svg x="0" y="0" width="$width" height="$height"
       viewBox="$offsetx $offsety $width $height" id="maze">
EOH
    }

    $output .= <<"EOH";
    <defs>
      <style type="text/css">
	path    { stroke: black; fill: none; }
	polygon { stroke: black; fill: grey; }
	#sprite { stroke: grey; stroke-width:0.2px; fill: $color->{sprite}; }
	.crumbs { fill:none; $crumbstyle }
	.mazebg { fill:$color->{mazebg}; stroke:none; }
	text { font-family: sans-serif; }
	.sign text {  fill:#fff;text-anchor:middle; font-weight:bold; }
	.exit rect {  fill:red; stroke:none; }
	.entry rect {  fill:green; stroke:none; }
	#solvedmsg { text-anchor:middle; pointer-events:none; font-size:80px; fill:red;
                   }
      </style>
      <circle id="savemark" r="3" fill="#6f6" stroke="none"/>
$sprite_def
@{[$self->wall_definitions()]}
    </defs>
    <rect id="mazebg" class="mazebg" x="$offsetx" y="$offsety" width="100%" height="100%"/>

$self->{mazeout}
    <polyline id="crumb" class="crumbs" stroke="$color->{crumb}" points="$xcrumb,$ycrumb"/>
    <use id="me" x="$xme" y="$yme" xlink:href="#sprite" visibility="hidden"/>

    <g transform="translate($xenter,$yenter)" class="entry sign">
      <rect x="-16" y="-8" width="35" height="16" rx="3" ry="3"/>
      <text x="2" y="4">Entry</text>
    </g>
    <g transform="translate($xexit,$yexit)" class="exit sign">
      <rect x="-16" y="-8" width="32" height="16" rx="3" ry="3"/>
      <text x="0" y="4">Exit</text>
    </g>
    <text id="solvedmsg" x="$cx" y="$cy" opacity="0">Solved!</text>
  </svg>
EOH

    if($self->{interactive})
    {
        $output .= $self->build_control_panel( 0, $height );
    }
    $output . "</svg>\n";
}


=item build_all_script

Generate the full set of script sections for the maze.

=over 4

=item $rows reference to an array of rows.

=back

=cut

sub build_all_script
{
    my $self = shift;
    my $rows = shift;
    
    my $script = qq{    <script type="text/ecmascript" xlink:href="$self->{dir}sprite.es"/>\n};
    $script  .= qq{    <script type="text/ecmascript" xlink:href="$self->{dir}maze.es"/>\n};
    $script  .= qq{    <script type="text/ecmascript" xlink:href="@{[$self->get_script()]}"/>\n};

    my $board = $self->make_board_array( $rows );

    $script .= qq{    <script type="text/ecmascript">\n}
              .qq{      var board = new Array();\n};
    my $i = 0;
    foreach my $row (@{$board})
    {
	$script .= qq{      board[$i] = new Array(}
                   . join( ', ', @{$row} )
	           . qq{ );\n};
	$i++;
    }
    $script .= <<'EOS';
    </script>
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
EOS

   $script;
}



=item build_control_panel

Create the displayable control panel

=over 4

=item $startx the starting x coordinate for the panel

=back

=cut

sub build_control_panel
{
    my $self = shift;
    my $startx = shift;
    my $height = shift;
    my $panelwidth = PANEL_WIDTH;

    my $offset = 20;
    my $output .= <<"EOB";
  <g id="control_panel" transform="translate($startx,0)">
    <rect x="0" y="0" width="$panelwidth" height="$height"
          class="panel"/>
EOB
    $output .= _create_text_button( 'restart', $offset, 20, 50, 20, 'Begin' );
    $output .= _create_text_button(
        'save_position', $offset+60, 20, 50, 20, 'Save'
    );
    $output .= _create_text_button(
        'restore_position', $offset+120, 20, 50, 20, 'Back'
    );
    $output .= <<"EOB";

    <g transform="translate(20,65)">
      <rect x="-2" y="-2" rx="25" ry="25" width="68" height="68"
          fill="none" stroke-width="0.5" stroke="black"/>
      <text x="34" y="-5" class="ctrllabel">Move View</text>
EOB
    $output .= _create_view_button( 'maze_up',    22,  0, '10,5 5,15 15,15' );
    $output .= _create_view_button( 'maze_left',   0, 22, '5,10 15,5 15,15' );
    $output .= _create_view_button( 'maze_right', 44, 22, '15,10 5,5 5,15' );
    $output .= _create_view_button( 'maze_down',  22, 44, '10,15 5,5 15,5' );
    $output .= _create_view_button( 'maze_reset', 22, 22, '7,7 7,13 13,13 13,7' );

=begin COMMENT

    $output .= <<"EOB";
    </g>
    <g transform="translate(110, 50)">
      <rect width="82" height="82" x="-1" y="-1" fill="gray" stroke-width="1" stroke="black"/>
EOB
    $output .= $self->_create_thumbnail();

=cut

    $output .= <<"EOB";
    </g>

    <g class="instruct" transform="translate($offset,165)">
      <text x="0" y="0">Click Begin button to start</text>
      <text x="0" y="30">Use the arrow keys to move the sprite</text>
      <text x="0" y="50">Hold the shift to move quickly.</text>
      <text x="0" y="70">The mouse must remain over the</text>
      <text x="0" y="90">maze for the keys to work.</text>
      <text x="0" y="120">Use arrow buttons to shift the maze</text>
      <text x="0" y="140">Center button restores position</text>
      <text x="0" y="160">Save button saves current position</text>
      <text x="0" y="180">Back button restores last position</text>
    </g>
  </g>
EOB
}


=begin COMMENT

# _create_thumbnail
#
# Create the thumbnail image used to show the player where they are on the
# larger field.
#
sub _create_thumbnail
{
    my $self = shift;
    my ($x, $y, $wid, $ht) = (0,0,80,80);
    
    if($self->{width} > $self->{height})
    {
        $ht = int(80 * $self->{height} / $self->{width});
	$y = (80 - $ht) / 2;
    }
    else
    {
        $wid = int(80 * $self->{width} / $self->{height});
	$x = (80 - $wid) / 2;
    }
    qq{      <rect x="$x" y="$y" width="$wid" height="$ht" class="mazebg"/>\n};
}

=cut

# _create_text_button
#
#  $function - function name to call
#  $x - x-coordinate of the button
#  $y - y-coordinate of the button
#  $width - width of the button
#  $height - height of the button
#  $text - text to be displayed on the button

sub _create_text_button
{
    my $fn = shift;
    my $x = shift;
    my $y = shift;
    my $width = shift;
    my $height = shift;
    my $text = shift;

    my $tx = $width/2;
    my $ty = $height/2 + 5;

    my $output = <<"EOF";

    <g onclick="$fn()" transform="translate($x,$y)" class="button"
       onmousedown="push(evt)" onmouseup="release(evt)" onmouseout="release(evt)">
      <rect x="0" y="0" width="$width" height="$height" rx="5" ry="5"/>
      <text x="$tx" y="$ty">$text</text>
    </g>
EOF

    $output;
}


# _create_view_button
#
#  $function - function name to call
#  $x - x-coordinate of the button
#  $y - y-coordinate of the button
#  $icon - list of points for the icon

sub _create_view_button
{
    my $fn = shift;
    my $x = shift;
    my $y = shift;
    my $icon = shift;

    my $output = <<"EOF";

      <g onclick="$fn()" transform="translate($x,$y)" class="button"
	 onmousedown="push(evt)" onmouseup="release(evt)" onmouseout="release(evt)">
	<rect x="0" y="0" width="20" height="20" rx="5" ry="5"/>
	<polygon points="$icon"/>
      </g>
EOF

    $output;
}


=item create_sprite

Create the sprite definition for inclusion in the SVG.

=cut

sub  create_sprite
{
    my $self = shift;
    my ($dx2, $dy2) = ($self->dx()/2, $self->dy()/2);

    qq|      | .
    qq|<path id="sprite" d="M0,0 Q$dx2,$dy2 0,@{[$self->dy()]} Q$dx2,$dy2 @{[$self->dx()]},@{[$self->dy()]} Q$dx2,$dy2 @{[$self->dx()]},0 Q$dx2,$dy2 0,0"/>|;
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
    my $self = shift;
    my $dx   = $self->dx();
    my $dy   = $self->dy();
    my $rows = shift;

    my $output = '';
    my ($maxx,$y) = (0,0);

    foreach my $r (@{$rows})
    {
        my $x = 0;
        foreach my $c (@{$r})
        {
            $output .= qq{    <use x="$x" y="$y" xlink:href="#$c"/>\n} if $c and $c ne '$';
            $x += $dx;
        }
        $y += $dy;
        $maxx = $x if $maxx < $x;
    }

    $self->{width} = $maxx;
    $self->{height} = $y;
    $self->{mazeout} = $output;

    $self;
}


=item dx

Returns the delta X value for building this maze.

=cut

sub dx
{
    my $self = shift;

    $self->{dx};
}


=item dy

Returns the delta Y value for building this maze.

=cut

sub dy
{
    my $self = shift;

    $self->{dy};
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
