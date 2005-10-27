#!perl -T

use Test::More tests => 10;
use Test::Exception;

use Games::Maze::SVG;

use strict;
use warnings;

my %crumbstyles = (
    dash => "stroke-width:1; stroke-dasharray:5,3;",
    dot  => "stroke-width:2; stroke-dasharray:2,6;",
    line => "stroke-width:1;",
    none => "visibility:hidden;",
);


my $maze = Games::Maze::SVG->new();

can_ok( $maze, "set_breadcrumb", "get_crumbstyle" );

foreach my $crumb (keys %crumbstyles)
{
    is( $maze->set_breadcrumb( $crumb ), $maze, "Successfully set crumbs." );
    is( $maze->get_crumbstyle(), $crumbstyles{$crumb}, " ... to $crumb" );
}

throws_ok { $maze->set_breadcrumb( "xyzzy" ); } 
          qr/Unrecognized breadcrumb style 'xyzzy'/,
	  "Bad crumbs stopped.";

