#!perl -T

use Test::More tests => 4;

use Games::Maze::SVG;

use strict;
use warnings;

# Test setting wall form

my $maze = Games::Maze::SVG->new( 'RectHex' );

can_ok( $maze, "set_wall_form" );

foreach my $form (qw/straight/)
{
    is( $maze->set_wall_form( $form ), $maze, "successful set wall form" );
    is( $maze->{wallform}, $form, " ... to $form" );
}


eval { $maze->set_wall_form( "xyzzy" ); };
like( $@, qr/'xyzzy' is not a valid wall form/, "Bad form stopped." );

