#!perl -T

use Test::More tests => 10;
use Test::Exception;

use Games::Maze::SVG;

use strict;
use warnings;

# Test setting wall form

my $maze = Games::Maze::SVG->new();

can_ok( $maze, "set_wall_form" );

foreach my $form (qw/straight round roundcorners bevel/)
{
    is( $maze->set_wall_form( $form ), $maze, "successful set wall form" );
    is( $maze->{wallform}, $form, " ... to $form" );
}

throws_ok { $maze->set_wall_form( "xyzzy" ); } 
          qr/'xyzzy' is not a valid wall form/,
	  "Bad form stopped.";

