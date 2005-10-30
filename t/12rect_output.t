#!perl -T

use Test::More tests => 1;
use Test::MockModule;

use Games::Maze::SVG;

use strict;
use warnings;

my $gmaze = Test::MockModule->new( 'Games::Maze' );

my $rectgrid = 

my $output = do { local $/ = undef; <DATA>; };

$gmaze->mock(
    make => sub {},
    to_ascii => sub { <<EOM },
:--:  :--:--:
|  |        |
:  :  :--:  :
|     |     |
:  :--:--:--:
|  |        |
:  :--:--:  :
|           |
:--:  :--:--:
EOM
);

# Default constructor.
my $maze = Games::Maze::SVG->new( 'Rect' );

is( $maze->toString(), $output, "Full transform works." );

#open( my $fh, '>rect1.svg' ) or die;
#print $fh $maze->toString();

__DATA__
<?xml version="1.0"?>
<svg width="70" height="90"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
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
    <path id="sprite" d="M0,0 Q5,5 0,10 Q5,5 10,10 Q5,5 10,0 Q5,5 0,0"/>
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
  <rect id="mazebg" x="0" y="0" width="70" height="90"/>

  <use x="0" y="0" xlink:href="#ul"/>
  <use x="10" y="0" xlink:href="#h"/>
  <use x="20" y="0" xlink:href="#td"/>
  <use x="30" y="0" xlink:href="#h"/>
  <use x="40" y="0" xlink:href="#td"/>
  <use x="50" y="0" xlink:href="#h"/>
  <use x="60" y="0" xlink:href="#ur"/>
  <use x="0" y="10" xlink:href="#v"/>
  <use x="20" y="10" xlink:href="#v"/>
  <use x="40" y="10" xlink:href="#v"/>
  <use x="60" y="10" xlink:href="#v"/>
  <use x="0" y="20" xlink:href="#tr"/>
  <use x="10" y="20" xlink:href="#h"/>
  <use x="20" y="20" xlink:href="#cross"/>
  <use x="30" y="20" xlink:href="#h"/>
  <use x="40" y="20" xlink:href="#cross"/>
  <use x="50" y="20" xlink:href="#h"/>
  <use x="60" y="20" xlink:href="#tl"/>
  <use x="0" y="30" xlink:href="#v"/>
  <use x="20" y="30" xlink:href="#v"/>
  <use x="40" y="30" xlink:href="#v"/>
  <use x="60" y="30" xlink:href="#v"/>
  <use x="0" y="40" xlink:href="#tr"/>
  <use x="10" y="40" xlink:href="#h"/>
  <use x="20" y="40" xlink:href="#cross"/>
  <use x="30" y="40" xlink:href="#h"/>
  <use x="40" y="40" xlink:href="#cross"/>
  <use x="50" y="40" xlink:href="#h"/>
  <use x="60" y="40" xlink:href="#tl"/>
  <use x="0" y="50" xlink:href="#v"/>
  <use x="20" y="50" xlink:href="#v"/>
  <use x="40" y="50" xlink:href="#v"/>
  <use x="60" y="50" xlink:href="#v"/>
  <use x="0" y="60" xlink:href="#ll"/>
  <use x="10" y="60" xlink:href="#h"/>
  <use x="20" y="60" xlink:href="#tu"/>
  <use x="30" y="60" xlink:href="#h"/>
  <use x="40" y="60" xlink:href="#tu"/>
  <use x="50" y="60" xlink:href="#h"/>
  <use x="60" y="60" xlink:href="#lr"/>




</svg>
