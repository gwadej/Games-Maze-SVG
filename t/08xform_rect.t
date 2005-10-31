#!perl

use Test::More tests => 7;

use Games::Maze::SVG;
use FindBin;
use lib "$FindBin::Bin/lib";
use MazeTestUtils;

use strict;
use warnings;

my $maze = Games::Maze::SVG->new( 'Rect' );
can_ok( $maze, "transform_grid" );

my $simplegrid = <<EOM;
:--:
|  |
:--:
EOM

my $simpleout = [
   [ qw/ul h ur/ ],
   [ qw/v 0 v/ ],
   [ qw/ll h lr/ ],
];
my $simplebevelout = [
   [ qw/oul oh our/ ],
   [ qw/ov 0 ov/ ],
   [ qw/oll oh olr/ ],
];


grid_ok( $simplegrid, 'straight', $simpleout, 'Simple Square' );
grid_ok( $simplegrid, 'bevel', $simplebevelout, 'Simple Bevel Square' );


my $rectgrid = <<EOM;
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

my $rectout = [
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

my $rectbevelout = [
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

grid_ok( $rectgrid, 'straight', $rectout, 'Small Rectangle' );
grid_ok( $rectgrid, 'bevel', $rectbevelout, 'Small Beveled Rectangle' );

my $rectgrid2 = <<EOM;
:--:  :--:--:
|     |     |
:  :--:--:  :
|     |     |
:--:  :  :  :
|     |  |  |
:  :--:  :  :
|        |  |
:--:  :--:--:
EOM

my $rectout2 = [
   [ qw/ul  h  l  0   ul  h  h  h ur/ ],
   [ qw/ v  0  0  0    v  0  0  0  v/ ],
   [ qw/ v  0  r  h cross h  l  0  v/ ],
   [ qw/ v  0  0  0    v  0  0  0  v/ ],
   [ qw/tr  h  l  0    v  0  d  0  v/ ],
   [ qw/ v  0  0  0    v  0  v  0  v/ ],
   [ qw/ v  0  r  h   lr  0  v  0  v/ ],
   [ qw/ v  0  0  0    0  0  v  0  v/ ],
   [ qw/ll  h  l  0    r  h tu  h lr/ ],
];

my $rectbevelout2 = [
   [ qw/oul oh ol  0  oul oh  oh oh our/ ],
   [ qw/ ov  0  0  0    v  0   0  0  ov/ ],
   [ qw/ ov  0  r  h cross h   l  0  ov/ ],
   [ qw/ ov  0  0  0    v  0   0  0  ov/ ],
   [ qw/otr  h  l  0    v  0   d  0  ov/ ],
   [ qw/ ov  0  0  0    v  0   v  0  ov/ ],
   [ qw/ ov  0  r  h   lr  0   v  0  ov/ ],
   [ qw/ ov  0  0  0    0  0   v  0  ov/ ],
   [ qw/oll oh ol  0   or oh otu oh olr/ ],
];

grid_ok( $rectgrid2, 'straight', $rectout2, 'Small Rectangle 2' );
grid_ok( $rectgrid2, 'bevel', $rectbevelout2, 'Small Beveled Rectangle 2' );


# Need more examples to be certain that I've covered all transforms.

# -----------------
# Subroutines

sub grid_ok
{
    my $grid = split_maze( shift );
    my $wall = shift;
    my $out = shift;
    my $msg = shift;

    is_deeply( [$maze->transform_grid( $grid, $wall )],
         $out, $msg );
}
