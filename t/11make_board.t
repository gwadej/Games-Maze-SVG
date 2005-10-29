#!perl

use Test::More tests => 5;

use Games::Maze::SVG;

use strict;
use warnings;

can_ok( "Games::Maze::SVG", "make_board_array" );

my $maze = Games::Maze::SVG->new();

my $rectangle = [
   [ qw/ul  h ur  0  r  h  h  h ur/ ],
   [ qw/ v  0  v  0  0  0  0  0  v/ ],
   [ qw/ v  0  t  0 ul  h  l  0  v/ ],
   [ qw/ v  0  0  0  v  0  0  0  v/ ],
   [ qw/ v  0 ul  h tu  h  h  h tl/ ],
   [ qw/ v  0  v  0  0  0  0  0  v/ ],
   [ qw/ v  0 ll  h  h  h  l  0  v/ ],
   [ qw/ v  0  0  0  0  0  0  0  v/ ],
   [ qw/ll  h  l  0  r  h  h  h lr/ ],
];

my $rect_board = [
   [ qw/1  1  1  0  1  1  1  1  1/ ],
   [ qw/1  0  1  0  0  0  0  0  1/ ],
   [ qw/1  0  1  0  1  1  1  0  1/ ],
   [ qw/1  0  0  0  1  0  0  0  1/ ],
   [ qw/1  0  1  1  1  1  1  1  1/ ],
   [ qw/1  0  1  0  0  0  0  0  1/ ],
   [ qw/1  0  1  1  1  1  1  0  1/ ],
   [ qw/1  0  0  0  0  0  0  0  1/ ],
   [ qw/1  1  1  0  1  1  1  1  1/ ],
];

is_deeply( $maze->make_board_array( $rectangle ),
           $rect_board,
	   "straight rectangle" );

my $rectanglebevel = [
   [ qw/oul oh our  0 or oh oh oh our/ ],
   [ qw/ ov  0   v  0  0  0  0  0  ov/ ],
   [ qw/ ov  0   t  0 ul  h  l  0  ov/ ],
   [ qw/ ov  0   0  0  v  0  0  0  ov/ ],
   [ qw/ ov  0  ul  h tu  h  h  h otl/ ],
   [ qw/ ov  0   v  0  0  0  0  0  ov/ ],
   [ qw/ ov  0  ll  h  h  h  l  0  ov/ ],
   [ qw/ ov  0   0  0  0  0  0  0  ov/ ],
   [ qw/oll oh  ol  0 or oh oh oh olr/ ],
];

my $rectbevel_board = [
   [ qw/1  1  1  0  1  1  1  1  1/ ],
   [ qw/1  0  1  0  0  0  0  0  1/ ],
   [ qw/1  0  1  0  1  1  1  0  1/ ],
   [ qw/1  0  0  0  1  0  0  0  1/ ],
   [ qw/1  0  1  1  1  1  1  1  1/ ],
   [ qw/1  0  1  0  0  0  0  0  1/ ],
   [ qw/1  0  1  1  1  1  1  0  1/ ],
   [ qw/1  0  0  0  0  0  0  0  1/ ],
   [ qw/1  1  1  0  1  1  1  1  1/ ],
];

is_deeply( $maze->make_board_array( $rectanglebevel ),
           $rectbevel_board,
	   "beveled rectangle" );

my $recthex = [
   [ qw/ 0  xh  xh  0   0  0   0  xh  xh  0   0  0  0  0/ ],
   [ qw/xsr  0   0 xsl xh xh  xsr  0   0 xsl  0  0  0  0/ ],
   [ qw/xsl  0   0 xsr  0  0   0  xh  xh  0   0  0 xsl 0/ ],
   [ qw/xsr  0   0 xsl  0  0  xsr  0   0  0  xh xh xsr 0/ ],
   [ qw/xsl  0   0 xsr  0  0  xsl xh  xh  0   0  0 xsl 0/ ],
   [ qw/xsr  0   0 xsl xh xh   0   0   0 xsl  0  0 xsr 0/ ],
   [ qw/xsl  0   0 xsr  0  0   0  xh  xh xsr  0  0 xsl 0/ ],
   [ qw/xsr  0   0 xsl  0  0  xsr  0   0 xsl  0  0 xsr 0/ ],
   [ qw/xsl xh  xh  0   0  0  xsl xh  xh  0   0  0 xsl 0/ ],
   [ qw/ 0   0  0  xsl xh  xh xsr  0  0  xsl  0  0 xsr 0/ ],
];

my $recthex_board = [
   [ qw/ 0  -1  -1  0   0  0   0  -1  -1  0   0  0  0  0/ ],
   [ qw/ 1   0   0  1  -1 -1   1   0   0  1   0  0  0  0/ ],
   [ qw/ 1   0   0  1   0  0   0  -1  -1  0   0  0  1  0/ ],
   [ qw/ 1   0   0  1   0  0   1   0   0  0  -1 -1  1  0/ ],
   [ qw/ 1   0   0  1   0  0   1  -1  -1  0   0  0  1  0/ ],
   [ qw/ 1   0   0  1  -1 -1   0   0   0  1   0  0  1  0/ ],
   [ qw/ 1   0   0  1   0  0   0  -1  -1  1   0  0  1  0/ ],
   [ qw/ 1   0   0  1   0  0   1   0   0  1   0  0  1  0/ ],
   [ qw/ 1  -1  -1  0   0  0   1  -1  -1  0   0  0  1  0/ ],
   [ qw/ 0   0  0   1  -1  -1  1   0  0   1   0  0  1  0/ ],
];

is_deeply( $maze->make_board_array( $recthex ),
           $recthex_board,
	   "rectangle, hex cells" );

my $hexagon = [
   [ qw| 0   0  0  0   0  0  0   0  0  0  xh xh  0   0  0  0   0  0  0   0  0  0  0| ],
   [ qw| 0   0  0  0   0  0  0   0  0 xsr  0  0 xsl xh xh  0   0  0  0   0  0  0  0| ],
   [ qw| 0   0  0  0  xh xh xsr  0  0 xsl  0  0  0   0  0 xsl xh xh  0   0  0  0  0| ],
   [ qw| 0  xh xh xsr  0  0 xsl  0  0  0   0  0 xsl xh xh  0   0  0 xsl xh xh  0  0| ],
   [ qw|xsr  0  0  0   0  0 xsr  0  0 xsl xh xh xsr  0  0  0  xh xh xsr  0  0 xsl 0| ],
   [ qw|xsl  0  0 xsr  0  0 xsl  0  0 xsr  0  0 xsl xh xh  0   0  0  0   0  0 xsr 0| ],
   [ qw|xsr  0  0 xsl xh xh  0   0  0 xsl xh xh  0   0  0 xsl xh xh xsr  0  0 xsl 0| ],
   [ qw|xsl  0  0  0   0  0 xsl xh xh xsr  0  0 xsl  0  0 xsr  0  0  0  xh xh xsr 0| ],
   [ qw|xsr  0  0 xsl xh xh  0   0  0  0   0  0 xsr  0  0 xsl xh xh  0   0  0 xsl 0| ],
   [ qw|xsl  0  0 xsr  0  0 xsl xh xh xsr  0  0 xsl  0  0 xsr  0  0 xsl  0  0 xsr 0| ],
   [ qw|xsr  0  0 xsl  0  0 xsr  0  0  0  xh xh xsr  0  0  0   0  0 xsr  0  0 xsl 0| ],
   [ qw|xsl xh xh  0   0  0 xsl  0  0 xsr  0  0 xsl xh xh xsr  0  0 xsl  0  0 xsr 0| ],
   [ qw| 0   0  0 xsl xh xh xsr  0  0 xsl  0  0  0   0  0  0  xh xh xsr  0  0  0  0| ],
   [ qw| 0   0  0  0   0  0 xsl xh xh  0   0  0 xsl xh xh xsr  0  0  0   0  0  0  0| ],
   [ qw| 0   0  0  0   0  0  0   0  0 xsl xh xh xsr  0  0  0   0  0  0   0  0  0  0| ],
];

my $hexagon_board = [
   [ qw|0  0  0  0  0  0  0  0  0  0 -1 -1  0  0  0  0  0  0  0  0  0  0  0| ],
   [ qw|0  0  0  0  0  0  0  0  0  1  0  0  1 -1 -1  0  0  0  0  0  0  0  0| ],
   [ qw|0  0  0  0 -1 -1  1  0  0  1  0  0  0  0  0  1 -1 -1  0  0  0  0  0| ],
   [ qw|0 -1 -1  1  0  0  1  0  0  0  0  0  1 -1 -1  0  0  0  1 -1 -1  0  0| ],
   [ qw|1  0  0  0  0  0  1  0  0  1 -1 -1  1  0  0  0 -1 -1  1  0  0  1  0| ],
   [ qw|1  0  0  1  0  0  1  0  0  1  0  0  1 -1 -1  0  0  0  0  0  0  1  0| ],
   [ qw|1  0  0  1 -1 -1  0  0  0  1 -1 -1  0  0  0  1 -1 -1  1  0  0  1  0| ],
   [ qw|1  0  0  0  0  0  1 -1 -1  1  0  0  1  0  0  1  0  0  0 -1 -1  1  0| ],
   [ qw|1  0  0  1 -1 -1  0  0  0  0  0  0  1  0  0  1 -1 -1  0  0  0  1  0| ],
   [ qw|1  0  0  1  0  0  1 -1 -1  1  0  0  1  0  0  1  0  0  1  0  0  1  0| ],
   [ qw|1  0  0  1  0  0  1  0  0  0 -1 -1  1  0  0  0  0  0  1  0  0  1  0| ],
   [ qw|1 -1 -1  0  0  0  1  0  0  1  0  0  1 -1 -1  1  0  0  1  0  0  1  0| ],
   [ qw|0  0  0  1 -1 -1  1  0  0  1  0  0  0  0  0  0 -1 -1  1  0  0  0  0| ],
   [ qw|0  0  0  0  0  0  1 -1 -1  0  0  0  1 -1 -1  1  0  0  0  0  0  0  0| ],
   [ qw|0  0  0  0  0  0  0  0  0  1 -1 -1  1  0  0  0  0  0  0  0  0  0  0| ],
];

is_deeply( $maze->make_board_array( $hexagon ),
           $hexagon_board,
	   "hexagonal maze" );

