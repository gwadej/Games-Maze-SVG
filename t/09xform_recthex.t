#!perl

use Test::More tests => 3;

use Games::Maze::SVG;
use FindBin;
use lib "$FindBin::Bin/lib";
use MazeTestUtils;

use strict;
use warnings;

my $maze = Games::Maze::SVG->new( "RectHex" );
can_ok( $maze, "transform_grid" );

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

grid_ok( $simplegrid, $simpleout, 'Simple Hex' );


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

grid_ok( $hexgrid, $hexout, 'hexagon' );


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
