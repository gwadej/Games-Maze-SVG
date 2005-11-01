#!perl

use Test::More tests => 1;
use Test::MockModule;
#use Test::LongString;
use FindBin;
use lib "$FindBin::Bin/lib";
use MazeTestUtils;

use Games::Maze::SVG;

use strict;
use warnings;

my $gmaze = Test::MockModule->new( 'Games::Maze' );

my $rectgrid = 

my $output = do { local $/ = undef; <DATA>; };

$gmaze->mock(
    make => sub { my $self = shift; $self->{entry} = [3,1]; $self->{exit} = [7,8]; },
    to_ascii => sub { normalize_maze( <<'EOM' ); },
          __
         /  \__
    __/  \     \__
 __/  \     \__   \__ 
/     /  \__/   __/  \
\  /  \  /  \__      /
/  \__   \__   \__/  \
\     \__/  \  /   __/
/  \__      /  \__   \
\  /  \__/  \  /  \  /
/  \  /   __/     /  \
\__   \  /  \__/  \  /
   \__/  \      __/
      \__   \__/  
         \__/
EOM
);

# Default constructor.
my $maze = Games::Maze::SVG->new( 'Hex' );
$maze->set_interactive();

#open( my $fh, '>hex1.svg' ) or die;
#print $fh $maze->toString();

#is_string( $maze->toString(), $output, "Full transform works." );
is( $maze->toString(), $output, "Full transform works." );

__DATA__
<?xml version="1.0"?>
<svg width="330" height="150"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     onload="initialize( board, {x:8, y:0}, {x:20, y:17}, {x:5, y:10} )"
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
    <path id="sprite" d="M0,0 Q2.5,5 0,10 Q2.5,5 5,10 Q2.5,5 5,0 Q2.5,5 0,0"/>
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
    <script type="text/ecmascript" xlink:href="scripts/hexmaze.es"/>
    <script type="text/ecmascript">
      var board = new Array();
      board[0] = new Array(0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0 );
      board[1] = new Array(0, 0, 0, 0, -1, -1, 1, 0, 0, 1, -1, -1, 0, 0, 0, 0 );
      board[2] = new Array(0, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 0 );
      board[3] = new Array(1, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 1 );
      board[4] = new Array(1, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 1 );
      board[5] = new Array(1, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 1 );
      board[6] = new Array(1, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 1 );
      board[7] = new Array(1, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 1 );
      board[8] = new Array(1, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 1 );
      board[9] = new Array(0, 0, 0, 1, -1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, 0 );
      board[10] = new Array(0, 0, 0, 0, 0, 0, 1, -1, -1, 1, 0, 0, 0, 0, 0, 0 );
      board[11] = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
      board[12] = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
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
  <rect id="mazebg" x="0" y="0" width="80" height="150"/>

  <use x="35" y="0" xlink:href="#xh"/>
  <use x="40" y="0" xlink:href="#xh"/>
  <use x="20" y="10" xlink:href="#xh"/>
  <use x="25" y="10" xlink:href="#xh"/>
  <use x="30" y="10" xlink:href="#xsr"/>
  <use x="45" y="10" xlink:href="#xsl"/>
  <use x="50" y="10" xlink:href="#xh"/>
  <use x="55" y="10" xlink:href="#xh"/>
  <use x="5" y="20" xlink:href="#xh"/>
  <use x="10" y="20" xlink:href="#xh"/>
  <use x="15" y="20" xlink:href="#xsr"/>
  <use x="30" y="20" xlink:href="#xsl"/>
  <use x="35" y="20" xlink:href="#xh"/>
  <use x="40" y="20" xlink:href="#xh"/>
  <use x="45" y="20" xlink:href="#xsr"/>
  <use x="60" y="20" xlink:href="#xsl"/>
  <use x="65" y="20" xlink:href="#xh"/>
  <use x="70" y="20" xlink:href="#xh"/>
  <use x="0" y="30" xlink:href="#xsr"/>
  <use x="15" y="30" xlink:href="#xsl"/>
  <use x="20" y="30" xlink:href="#xh"/>
  <use x="25" y="30" xlink:href="#xh"/>
  <use x="30" y="30" xlink:href="#xsr"/>
  <use x="45" y="30" xlink:href="#xsl"/>
  <use x="50" y="30" xlink:href="#xh"/>
  <use x="55" y="30" xlink:href="#xh"/>
  <use x="60" y="30" xlink:href="#xsr"/>
  <use x="75" y="30" xlink:href="#xsl"/>
  <use x="0" y="40" xlink:href="#xsl"/>
  <use x="5" y="40" xlink:href="#xh"/>
  <use x="10" y="40" xlink:href="#xh"/>
  <use x="15" y="40" xlink:href="#xsr"/>
  <use x="30" y="40" xlink:href="#xsl"/>
  <use x="35" y="40" xlink:href="#xh"/>
  <use x="40" y="40" xlink:href="#xh"/>
  <use x="45" y="40" xlink:href="#xsr"/>
  <use x="60" y="40" xlink:href="#xsl"/>
  <use x="65" y="40" xlink:href="#xh"/>
  <use x="70" y="40" xlink:href="#xh"/>
  <use x="75" y="40" xlink:href="#xsr"/>
  <use x="0" y="50" xlink:href="#xsr"/>
  <use x="15" y="50" xlink:href="#xsl"/>
  <use x="20" y="50" xlink:href="#xh"/>
  <use x="25" y="50" xlink:href="#xh"/>
  <use x="30" y="50" xlink:href="#xsr"/>
  <use x="45" y="50" xlink:href="#xsl"/>
  <use x="50" y="50" xlink:href="#xh"/>
  <use x="55" y="50" xlink:href="#xh"/>
  <use x="60" y="50" xlink:href="#xsr"/>
  <use x="75" y="50" xlink:href="#xsl"/>
  <use x="0" y="60" xlink:href="#xsl"/>
  <use x="5" y="60" xlink:href="#xh"/>
  <use x="10" y="60" xlink:href="#xh"/>
  <use x="15" y="60" xlink:href="#xsr"/>
  <use x="30" y="60" xlink:href="#xsl"/>
  <use x="35" y="60" xlink:href="#xh"/>
  <use x="40" y="60" xlink:href="#xh"/>
  <use x="45" y="60" xlink:href="#xsr"/>
  <use x="60" y="60" xlink:href="#xsl"/>
  <use x="65" y="60" xlink:href="#xh"/>
  <use x="70" y="60" xlink:href="#xh"/>
  <use x="75" y="60" xlink:href="#xsr"/>
  <use x="0" y="70" xlink:href="#xsr"/>
  <use x="15" y="70" xlink:href="#xsl"/>
  <use x="20" y="70" xlink:href="#xh"/>
  <use x="25" y="70" xlink:href="#xh"/>
  <use x="30" y="70" xlink:href="#xsr"/>
  <use x="45" y="70" xlink:href="#xsl"/>
  <use x="50" y="70" xlink:href="#xh"/>
  <use x="55" y="70" xlink:href="#xh"/>
  <use x="60" y="70" xlink:href="#xsr"/>
  <use x="75" y="70" xlink:href="#xsl"/>
  <use x="0" y="80" xlink:href="#xsl"/>
  <use x="5" y="80" xlink:href="#xh"/>
  <use x="10" y="80" xlink:href="#xh"/>
  <use x="15" y="80" xlink:href="#xsr"/>
  <use x="30" y="80" xlink:href="#xsl"/>
  <use x="35" y="80" xlink:href="#xh"/>
  <use x="40" y="80" xlink:href="#xh"/>
  <use x="45" y="80" xlink:href="#xsr"/>
  <use x="60" y="80" xlink:href="#xsl"/>
  <use x="65" y="80" xlink:href="#xh"/>
  <use x="70" y="80" xlink:href="#xh"/>
  <use x="75" y="80" xlink:href="#xsr"/>
  <use x="15" y="90" xlink:href="#xsl"/>
  <use x="20" y="90" xlink:href="#xh"/>
  <use x="25" y="90" xlink:href="#xh"/>
  <use x="30" y="90" xlink:href="#xsr"/>
  <use x="45" y="90" xlink:href="#xsl"/>
  <use x="50" y="90" xlink:href="#xh"/>
  <use x="55" y="90" xlink:href="#xh"/>
  <use x="60" y="90" xlink:href="#xsr"/>
  <use x="30" y="100" xlink:href="#xsl"/>
  <use x="35" y="100" xlink:href="#xh"/>
  <use x="40" y="100" xlink:href="#xh"/>
  <use x="45" y="100" xlink:href="#xsr"/>

  <polyline id="crumb" class="crumbs" stroke="#f3f" points="8,0"/>
  <use id="me" x="8" y="0" xlink:href="#sprite" visibility="hidden"/>

  <rect x="80" y="0" width="250" height="150"
        class="panel"/>

  <g onclick="restart()" transform="translate(100,20)"
     onmousedown="push(evt)" onmouseup="release(evt)" onmouseout="release(evt)">
    <rect x="0" y="0" width="50" height="20" rx="5" ry="5"
          class="button"/>
    <text x="25" y="15" class="button">Begin</text>
  </g>
  
  <g class="instruct" transform="translate(100,70)">
    <text x="0" y="0">Click Begin button to start</text>
    <text x="0" y="30">Use the arrow keys to move the sprite</text>
    <text x="0" y="50">Hold the shift to move quickly.</text>
    <text x="0" y="80">The mouse must remain over the</text>
    <text x="0" y="100">maze for the keys to work.</text>
  </g>
  <g transform="translate(105,200)" class="sign">
    <rect x="-16" y="-8" width="32" height="16" rx="3" ry="3"/>
    <text x="0" y="4">Exit</text>
  </g>
  <text id="solvedmsg" x="40" y="100" opacity="1.0">Solved!</text>

</svg>