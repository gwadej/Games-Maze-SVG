#!perl -T

use Test::More tests => 16;

use Games::Maze::SVG;

use strict;
use warnings;

# Default constructor.
my $maze = Games::Maze::SVG->new( 'Rect' );

isa_ok( $maze, 'Games::Maze::SVG', "Correct base type" );
isa_ok( $maze, 'Games::Maze::SVG::Rect', "Correct type" );

can_ok( $maze, qw/is_hex is_hex_shaped toString get_script/ );

ok( !$maze->is_hex(), "Not hex cells" );
ok( !$maze->is_hex_shaped(), "Not hex shaped" );
like( $maze->get_script(), qr/rectmaze\.es/, "Correct script name" );

is( $maze->{wallform}, 'round', "wall form defaults correctly" );
is( $maze->{crumb}, 'dash', "crumb style defaults correctly" );
is( $maze->{dx}, 10, "delta x defaults correctly" );
is( $maze->{dy}, 10, "delta y defaults correctly" );
is( $maze->{dir}, 'scripts/', "directory defaults correctly" );

$maze = Games::Maze::SVG->new( 'Rect',
   wallform => 'bevel', crumb => 'dot', dx => 15, dy => 13, dir => '/svg/'
);

is( $maze->{wallform}, 'bevel', "wall form set correctly" );
is( $maze->{crumb}, 'dot', "crumb style set correctly" );
is( $maze->{dx}, 15, "delta x set correctly" );
is( $maze->{dy}, 13, "delta y set correctly" );
is( $maze->{dir}, '/svg/', "directory set correctly" );
