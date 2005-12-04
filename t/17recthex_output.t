#!perl

use Test::More tests => 1;
use Test::MockModule;
use FindBin;
use lib "$FindBin::Bin/lib";
use MazeTestUtils;
use TestString;

use Games::Maze::SVG;

use strict;
use warnings;

my $gmaze = Test::MockModule->new( 'Games::Maze' );

my $rectgrid = 

my $output = do { local $/ = undef; <DATA>; };

$gmaze->mock(
    make => sub { my $self = shift; $self->{entry} = [2,1]; $self->{exit} = [6,8]; },
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
my $maze = Games::Maze::SVG->new( 'RectHex', cols => 3, rows => 3 );

#open( my $fh, '>recthex1.svg' ) or die;
#print $fh $maze->toString();

#is( $maze->toString(), $output, "Full transform works." );
is_string( $maze->toString(), $output, "Full transform works." );


__DATA__
<?xml version="1.0"?>
<svg width="70" height="130"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
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

  <svg x="0" y="0" width="70" height="130"
       viewBox="-10 -20 70 130" id="maze">
    <defs>
      <style type="text/css">
	path    { stroke: black; fill: none; }
	polygon { stroke: black; fill: grey; }
	#sprite { stroke: grey; stroke-width:0.2px; fill: orange; }
	.crumbs { fill:none; stroke-width:1px; stroke-dasharray:5px,3px; }
	.mazebg { fill:#ffc; stroke:none; }
	text { font-family: sans-serif; }
	.sign text {  fill:#fff;text-anchor:middle; font-weight:bold; }
	.exit rect {  fill:red; stroke:none; }
	.entry rect {  fill:green; stroke:none; }
	#solvedmsg { text-anchor:middle; pointer-events:none; font-size:80px; fill:red;
                   }
      </style>
      <circle id="savemark" r="3" fill="#6f6" stroke="none"/>
      <path id="sprite" d="M0,0 Q2.5,5 0,10 Q2.5,5 5,10 Q2.5,5 5,0 Q2.5,5 0,0"/>
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

    </defs>
    <rect id="mazebg" class="mazebg" x="-10" y="-20" width="100%" height="100%"/>

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

    <polyline id="crumb" class="crumbs" stroke="#f3f" points="27.5,5"/>
    <use id="me" x="25" y="0" xlink:href="#sprite" visibility="hidden"/>

    <g transform="translate(25,0)" class="entry sign">
      <rect x="-16" y="-8" width="35" height="16" rx="3" ry="3"/>
      <text x="2" y="4">Entry</text>
    </g>
    <g transform="translate(85,190)" class="exit sign">
      <rect x="-16" y="-8" width="32" height="16" rx="3" ry="3"/>
      <text x="0" y="4">Exit</text>
    </g>
    <text id="solvedmsg" x="25" y="80" opacity="0">Solved!</text>
  </svg>
</svg>
