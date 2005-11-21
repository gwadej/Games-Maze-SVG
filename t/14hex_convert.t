#!perl

use Test::More tests => 20;
use Test::MockModule;
use FindBin;
use lib "$FindBin::Bin/lib";
use MazeTestUtils;

use Games::Maze::SVG;

use strict;
use warnings;

my $maze = Games::Maze::SVG->new( 'Hex' );

my ($x, $y) = $maze->convert_start_position( 1, 1 );
is( $x, 2, "start origin x is correct" );
is( $y, 0, "start origin y is correct" );

($x, $y) = $maze->convert_start_position( 10, 10 );
is( $x, 29, "start calc x is correct" );
is( $y, 18, "start calc y is correct" );

($x, $y) = $maze->convert_end_position( 1, 1 );
is( $x, 2, "end origin x is correct" );
is( $y, 3, "end origin y is correct" );

($x, $y) = $maze->convert_end_position( 10, 10 );
is( $x, 29, "end calc x is correct" );
is( $y, 21, "end calc y is correct" );

$maze->{height} = 10*$maze->dy();
$maze->{width} = 10*$maze->dx();

($x, $y) = $maze->convert_sign_position( 1, 1 );
is( $x, 0, "entry sign x is correct" );
is( $y, 10, "entry sign y is correct" );

($x, $y) = $maze->convert_sign_position( 10, 10 );
is( $x, 55, "exit sign x is correct" );
is( $y, 130, "exit sign y is correct" );

# check edge conditions
($x, $y) = $maze->convert_sign_position( 10, 5 );
is( $x, 55, "exit sign below middle x is correct" );
is( $y, 50, "exit sign below middle y is correct" );

($x, $y) = $maze->convert_sign_position( 10, 6 );
is( $x, 55, "exit sign below middle x is correct" );
is( $y, 90, "exit sign below middle y is correct" );

($x, $y) = $maze->convert_sign_position( 5, 10 );
is( $x, 20, "exit sign left x is correct" );
is( $y, 130, "exit sign left y is correct" );

($x, $y) = $maze->convert_sign_position( 6, 10 );
is( $x, 35, "exit sign right x is correct" );
is( $y, 130, "exit sign right y is correct" );

