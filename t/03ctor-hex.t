#!perl -T

use Test::More tests => 5;

use Games::Maze::SVG;

use strict;
use warnings;

# Default constructor.
my $maze = Games::Maze::SVG->new( 'Hex' );

isa_ok( $maze, 'Games::Maze::SVG', "Correct type" );

can_ok( $maze, qw/is_hex is_hex_shaped toString get_script/ );

ok( $maze->is_hex(), "Has hex cells" );
ok( $maze->is_hex_shaped(), "Is hex shaped" );
like( $maze->get_script(), qr/hexmaze\.es/, "Correct script name" );
