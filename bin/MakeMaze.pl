#!/usr/bin/perl -w

use strict;

use Games::Maze;
use Games::Maze::Ascii;
use Games::Maze::SVG;
use Getopt::Std;

# Parse command line
my %opts = ();

getopts( 'xXSs:e:n:o:f:b:i', \%opts ) || usage();

usage() if @ARGV == 1;

# Prepare to generate output
my $type = 'Rect';
$type = 'RectHex' if $opts{x};
$type = 'Hex' if $opts{X};
my $build_maze = $opts{S} ? Games::Maze::SVG->new( $type ) : Games::Maze::Ascii->new();
my $out = \*STDOUT;

if($opts{o})
 {
  $out = undef;
  open( $out, ">$opts{o}" ) or die "Unable to create $opts{o}: $!";
 }

# extract parameters from command line
my $desc = get_maze_desc( \%opts, @ARGV );
$build_maze->{mazeparms} = { %{$desc}, %{$build_maze->{mazeparms}} };
$build_maze->set_wall_form( $opts{f} ) if $opts{f};
$build_maze->set_interactive() if $opts{i};
$build_maze->set_breadcrumb( $opts{b} ) if $opts{b};

# build maze
my $num = $opts{n} || 1;
print $out $build_maze->toString() while $num-- > 0;


# ----------------------------------------
# Subroutines

# ----------------------
# Get maze description from the parsed \%opts from the command
# line and the remaining command line parameters.
#
# returns  name of the wall description
#          the description hash
sub  get_maze_desc
 {
  my $opts     = shift;

  my $defdims  = [18,24,1];
  my $defxdims = [12,12,1];

  my $dims = $opts->{X} ? $defxdims : $defdims;
  if(@_)
   {
    $dims = [ @_[0..2] ];
    $dims->[2] ||= 1;
    $dims->[2] = 1 if $opts->{S}; # SVG mazes are 1 level for now
   }

  my %desc = ( dimensions => $dims );

#  $desc{cell} = 'Hex'     if $opts->{x} || $opts->{X};
#  $desc{form} = 'Hexagon' if $opts->{X};
  if(defined $opts->{s})
   {
    unless($opts->{s} >= 1 and $opts->{s} <= $dims->[0])
     {
      die "Starting column out of range.\n";
     } 
    $desc{entry} = [ $opts->{s}, 1, 1 ];
   }
  if(defined $opts->{e})
   {
    unless($opts->{e} >= 1 and $opts->{e} <= $dims->[0])
     {
      die "Ending column out of range.\n";
     } 
    $desc{exit} = [ $opts->{e}, @{$dims}[1,2] ];
   }

  (\%desc);
 }

# ----------------------
#  Usage message if parameters are messed up.
sub usage
 {
  (my $prog = $0) =~ s/^.\///;
  print <<EOH;
Usage: $prog  [-x] [-X] [cols rows [levels]]

where   -x       specifies hexagonal cells
        -X       specifies a hexagonal maze with hexagonal cells
	-S       generates an SVG version of the maze
	-s col   what column holds the entrance
	-e col   what column holds the exit
	-f form  wall forms (straight|round|roundcorners|bevel)
	-n num   how many mazes to print.
	-o file  write to a file not the screen
	-i       interactive mode (only for SVG)
	-b style breadcrumb style (dash|dot|line|none)
EOH
  exit 1;
 }

