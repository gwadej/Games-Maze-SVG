#!/usr/bin/perl -w

use Games::Maze;
use Games::Maze::SVG;
use CGI;
use strict;

$| = 1;

my $q = CGI::new();
my %parms = $q->Vars();
# Fixup for new HTML style
if($parms{style})
 {
  my @pieces = split( ':', $parms{style} );
  $parms{walls} = $pieces[1];
  $parms{cell}  = "hex" if $pieces[0] =~ /^[Hh]ex/;
  $parms{shape} = "hex" if $pieces[0] eq "Hex";
 }

# Prepare to generate output
my $build_maze = Games::Maze::SVG->new( dir => '/svg/');

# extract parameters from command line
my $desc = eval { get_maze_desc( \%parms ); };
if($@)
 {
  my $err = $@;
  print $q->header, $q->start_html, $q->h1( $err ),
        $q->p( "Press back button and try again." ),
        $q->end_html;
  exit 0;
 }

$build_maze->{mazeparms} = $desc;
$build_maze->set_wall_form( $parms{walls} ) if $parms{walls};
$build_maze->set_interactive();
$build_maze->set_breadcrumb( $parms{crumb} ) if $parms{crumb};

my $svg = $build_maze->toString();
print $q->header( -type => "image/svg+xml", -Content_length => length $svg ),
      $svg;


# ----------------------------------------
# Subroutines

# ----------------------
# Get maze description from the parsed \%parms from the cgi request
#
# returns  the description hash
sub  get_maze_desc
 {
  my $parms    = shift;

  my $defdims  = [18,24,1];
  my $defxdims = [12,12,1];

  my $dims = $parms->{hex} ? $defxdims : $defdims;
  $dims->[0] = $parms->{width} if $parms->{width};
  $dims->[1] = $parms->{height} if $parms->{height};

  my %desc = ( dimensions => $dims );

  $desc{cell} = 'Hex'     if ($parms->{cell}||'') eq "hex";
  $desc{form} = 'Hexagon' if ($parms->{shape}||'') eq "hex";
  if($parms->{enter})
   {
    unless($parms->{enter} >= 1 and $parms->{enter} <= $dims->[0])
     {
      die "Starting column out of range.\n";
     } 
    $desc{entry} = [ $parms->{enter}, 1, 1 ];
   }
  if($parms->{exit})
   {
    unless($parms->{exit} >= 1 and $parms->{exit} <= $dims->[0])
     {
      die "Ending column out of range.\n";
     } 
    $desc{exit} = [ $parms->{exit}, @{$dims}[1,2] ];
   }

  (\%desc);
 }
