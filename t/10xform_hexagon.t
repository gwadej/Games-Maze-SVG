#!perl -T

use Test::More tests => 3;

use Games::Maze::SVG;

use strict;
use warnings;

can_ok( "Games::Maze::SVG", "transform_hex_grid" );

my $simplegrid = <<'EOM';
 __
/  \
\__/
EOM

my $simpleout = [
   [ qw/ 0  xh xh  0/ ],
   [ qw/xsr  0  0 xsl/ ],
   [ qw/xsl xh xh xsr/ ],
];

grid_ok( $simplegrid, $simpleout, 'Simple Hex' );

# Warning: Trailing spaces are important in the following.
my $hexgrid = <<'EOM';
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

my $hexout = [
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

grid_ok( $hexgrid, $hexout, 'Hexagon maze' );

# Need more examples to be certain that I've covered all transforms.

# -----------------
# Subroutines

sub split_maze
{
    my $maze = shift;

    [ map { [ split //, $_ ] } split( /\n/, $maze ) ];
}


sub grid_ok
{
    my $grid = split_maze( shift );
    my $out = shift;
    my $msg = shift;

    is_deeply( [Games::Maze::SVG::transform_hex_grid( $grid )],
         $out, $msg );
}
