#!perl

use Test::More tests => 6;

use Games::Maze::SVG;
use FindBin;
use lib "$FindBin::Bin/lib";
use MazeTestUtils;

use strict;
use warnings;

my $maze = Games::Maze::SVG->new( "RectHex" );
can_ok( $maze, "transform_grid", "make_board_array" );

my $simplegrid = <<'EOM';
 __ 
/  \
\__/
EOM

my $simpleout = [
   [ qw/ 0  xh xh  0  0/ ],
   [ qw/xsr  0  0 xsl 0/ ],
   [ qw/xsl xh xh xsr 0/ ],
];

my $simpleboard = [
   [ qw/ 0  -1 -1  0  0/ ],
   [ qw/ 1   0  0  1  0/ ],
   [ qw/ 1  -1 -1  1  0/ ],
];

grid_ok( $simplegrid, $simpleout, 'Simple Hex grid' );
board_ok( $simplegrid, $simpleboard, 'Simple Hex board' );

my $hexgrid = normalize_maze( <<'EOM' );
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

my $hexout = [
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

my $hexboard = [
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

grid_ok( $hexgrid, $hexout, 'hexagon grid' );
board_ok( $hexgrid, $hexboard, 'hexagon board' );

eval { $maze->transform_grid( [ [ qw/| | | |/ ] ], 'straight' ) };
like( $@, qr/Missing block for '/, "Test non-xform of invalid grid." );

# Need more examples to be certain that I've covered all transforms.

# -----------------
# Subroutines

sub grid_ok
{
    my $grid = split_maze( shift );
    my $out = shift;
    my $msg = shift;

    is_deeply( [$maze->transform_grid( $grid, 'straight' )],
         $out, $msg );
}

sub board_ok
{
    my $grid = split_maze( shift );
    my $board = shift;
    my $msg = shift;

    my $rows = [$maze->transform_grid( $grid, 'straight' )];

    is_deeply( $maze->make_board_array( $rows), $board, $msg );
}
