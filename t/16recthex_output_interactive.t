#!perl

use Test::More tests => 1;
use Test::MockModule;
use FindBin;
use lib "$FindBin::Bin/lib";
use MazeTestUtils;
use Test::LongString;

use Games::Maze::SVG;

use strict;
use warnings;

my $gmaze = Test::MockModule->new( 'Games::Maze' );

my $rectgrid = 

my $output = do { local $/ = undef; <DATA>; };

$gmaze->mock(
    make => sub { my $self = shift; $self->{entry} = [4,0]; $self->{exit} = [4,5]; },
    to_ascii => sub { normalize_maze( <<'EOM' ); },
 __    __    
/  \__/  \
\  /   __   \
/  \  /   __/
\  /  \__   \
/  \__   \  /
\  /   __/  \
/  \  /  \  /
\__   \__   \
   \__/  \  /

EOM
);

# Default constructor.
my $maze = Games::Maze::SVG->new( 'RectHex' );
$maze->set_interactive();

#open( my $fh, '>recthex1.svg' ) or die;
#print $fh $maze->toString();

#is( $maze->toString(), $output, "Full transform works." );
is_string( $maze->toString(), $output, "Full transform works." );


__DATA__
<?xml version="1.0"?>
<svg width="300" height="110"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     onload="initialize( board, {x:11, y:-2}, {x:11, y:11}, {x:5, y:10} )"
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
    <script type="text/ecmascript" xlink:href="scripts/hexmaze.es"/>
    <script type="text/ecmascript">
      var board = new Array();
      board[0] = new Array(0, -1, -1, 0, 0, 0, 0, -1, -1, 0 );
      board[1] = new Array(1, 0, 0, 1, -1, -1, 1, 0, 0, 1 );
      board[2] = new Array(1, -1, -1, 1, 0, 0, 1, -1, -1, 1 );
      board[3] = new Array(1, 0, 0, 1, -1, -1, 1, 0, 0, 1 );
      board[4] = new Array(1, -1, -1, 1, 0, 0, 1, -1, -1, 1 );
      board[5] = new Array(1, 0, 0, 1, -1, -1, 1, 0, 0, 1 );
      board[6] = new Array(1, -1, -1, 1, 0, 0, 1, -1, -1, 1 );
      board[7] = new Array(0, 0, 0, 1, -1, -1, 1, 0, 0, 0 );
      board[8] = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
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

  </defs>
  <svg x="0" y="0" width="50" height="110"
       viewBox="0 0 50 110">
    <defs>
      <style type="text/css">
	path    { stroke: black; fill: none; }
	polygon { stroke: black; fill: grey; }
	#sprite { stroke: grey; stroke-width:0.2; fill: orange; }
	.crumbs { fill:none; stroke-width:1; stroke-dasharray:5,3; }
	#mazebg { fill:#ffc; stroke:none; }
	.panel  { fill:#ccc; stroke:none; }
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
      <path id="sprite" d="M0,0 Q2.5,5 0,10 Q2.5,5 5,10 Q2.5,5 5,0 Q2.5,5 0,0"/>
      <path id="xh"  d="M0,10 h5"/>
      <path id="xsr" d="M0,10 l5,-10"/>
      <path id="xsl" d="M0,0  l5,10"/>

    </defs>
    <rect id="mazebg" x="0" y="0" width="100%" height="100%"/>

    <use x="5" y="0" xlink:href="#xh"/>
    <use x="10" y="0" xlink:href="#xh"/>
    <use x="35" y="0" xlink:href="#xh"/>
    <use x="40" y="0" xlink:href="#xh"/>
    <use x="0" y="10" xlink:href="#xsr"/>
    <use x="15" y="10" xlink:href="#xsl"/>
    <use x="20" y="10" xlink:href="#xh"/>
    <use x="25" y="10" xlink:href="#xh"/>
    <use x="30" y="10" xlink:href="#xsr"/>
    <use x="45" y="10" xlink:href="#xsl"/>
    <use x="0" y="20" xlink:href="#xsl"/>
    <use x="5" y="20" xlink:href="#xh"/>
    <use x="10" y="20" xlink:href="#xh"/>
    <use x="15" y="20" xlink:href="#xsr"/>
    <use x="30" y="20" xlink:href="#xsl"/>
    <use x="35" y="20" xlink:href="#xh"/>
    <use x="40" y="20" xlink:href="#xh"/>
    <use x="45" y="20" xlink:href="#xsr"/>
    <use x="0" y="30" xlink:href="#xsr"/>
    <use x="15" y="30" xlink:href="#xsl"/>
    <use x="20" y="30" xlink:href="#xh"/>
    <use x="25" y="30" xlink:href="#xh"/>
    <use x="30" y="30" xlink:href="#xsr"/>
    <use x="45" y="30" xlink:href="#xsl"/>
    <use x="0" y="40" xlink:href="#xsl"/>
    <use x="5" y="40" xlink:href="#xh"/>
    <use x="10" y="40" xlink:href="#xh"/>
    <use x="15" y="40" xlink:href="#xsr"/>
    <use x="30" y="40" xlink:href="#xsl"/>
    <use x="35" y="40" xlink:href="#xh"/>
    <use x="40" y="40" xlink:href="#xh"/>
    <use x="45" y="40" xlink:href="#xsr"/>
    <use x="0" y="50" xlink:href="#xsr"/>
    <use x="15" y="50" xlink:href="#xsl"/>
    <use x="20" y="50" xlink:href="#xh"/>
    <use x="25" y="50" xlink:href="#xh"/>
    <use x="30" y="50" xlink:href="#xsr"/>
    <use x="45" y="50" xlink:href="#xsl"/>
    <use x="0" y="60" xlink:href="#xsl"/>
    <use x="5" y="60" xlink:href="#xh"/>
    <use x="10" y="60" xlink:href="#xh"/>
    <use x="15" y="60" xlink:href="#xsr"/>
    <use x="30" y="60" xlink:href="#xsl"/>
    <use x="35" y="60" xlink:href="#xh"/>
    <use x="40" y="60" xlink:href="#xh"/>
    <use x="45" y="60" xlink:href="#xsr"/>
    <use x="15" y="70" xlink:href="#xsl"/>
    <use x="20" y="70" xlink:href="#xh"/>
    <use x="25" y="70" xlink:href="#xh"/>
    <use x="30" y="70" xlink:href="#xsr"/>

    <polyline id="crumb" class="crumbs" stroke="#f3f" points="11,-2"/>
    <use id="me" x="11" y="-2" xlink:href="#sprite" visibility="hidden"/>

    <g transform="translate(55,130)" class="sign">
      <rect x="-16" y="-8" width="32" height="16" rx="3" ry="3"/>
      <text x="0" y="4">Exit</text>
    </g>
    <text id="solvedmsg" x="25" y="80" opacity="0">Solved!</text>
  </svg>
  <rect x="50" y="0" width="250" height="110"
        class="panel"/>

  <g onclick="restart()" transform="translate(70,20)"
     onmousedown="push(evt)" onmouseup="release(evt)" onmouseout="release(evt)">
    <rect x="0" y="0" width="50" height="20" rx="5" ry="5"
          class="button"/>
    <text x="25" y="15" class="button">Begin</text>
  </g>
  
  <g class="instruct" transform="translate(70,70)">
    <text x="0" y="0">Click Begin button to start</text>
    <text x="0" y="30">Use the arrow keys to move the sprite</text>
    <text x="0" y="50">Hold the shift to move quickly.</text>
    <text x="0" y="80">The mouse must remain over the</text>
    <text x="0" y="100">maze for the keys to work.</text>
  </g>

</svg>
