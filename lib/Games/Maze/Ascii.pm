#  Ascii maze output
#  Performs transformation, cleanup, and printing of output of Games::Maze

package Games::Maze::Ascii;

use Games::Maze;
use strict;

=head1 NAME

Games::Maze::Ascii - Build mazes in Ascii.

=head1 VERSION

Version 0.5

=cut

our $VERSION = 0.5;

=head1 SYNOPSIS

Games::Maze::Ascii uses the Games::Maze module to create mazes in Ascii.

    use Games::Maze::Ascii;

    my $foo = Games::Maze::Ascii->new();
    ...

=cut

=head1 FUNCTIONS

=over 4

=item new

Create a new Games::Maze::SVG object. Supports the following named parameters:

=cut

sub  new
 {
  my $obj = 
         {
          mazeparms => {},
         };

  bless $obj;
 }


=item is_hex

Method returns true if the maze is made of hexagonal cells.

=cut

sub  is_hex
 {
  my $self = shift;
  
  'Hex' eq ($self->{mazeparms}->{cell}||'');
 }


=item is_hex_shaped

Method returns true if the overall shape of the maze is a hexagon.

=cut

sub  is_hex_shaped
 {
  my $self = shift;
  
  'Hex' eq ($self->{mazeparms}->{shape}||'');
 }

=item toString

Method that converts the current maze into an Ascii string.

=cut

sub  toString
 {
  my $self = shift;
  my $maze = Games::Maze->new( %{$self->{mazeparms}} );
  $maze->make();
  $maze->to_ascii();
 }

=item set_wall_form

Set the wall format for the current maze. Not allowed.

=cut

sub  set_wall_form
 {
  my $self = shift;
  die "You can't change the form of an Ascii maze.\n";

  $self;
 }


=item set_interactive

Method makes the maze interactive.

Not allowed.

=cut

sub  set_interactive
 {
  my $self = shift;
  die "Ascii mazes can't be interactive.\n";

  $self;
 }


=back

=head1 AUTHOR

G. Wade Johnson, C<< <wade@anomaly.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-maze-svg1@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Maze-SVG1>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2004-2005 G. Wade Johnson, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
