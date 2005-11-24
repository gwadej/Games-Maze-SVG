/**
 * File: maze.es
 *
 * Provide common interactive effects for a maze.
 */

var shifted = false;

var game;
var sprite;

/*
 * The MazeGame object will maintain the current state of the game and
 * update the display.
 */

function MazeGame( start, end, board )
{
    this.start = start;
    this.end = end;
    this.board = board;

    this.maze = document.getElementById( "maze" );
    this.origin = this.maze.getAttributeNS( null, "viewBox" );
}

MazeGame.prototype.isFinished = function( pt )
{
    return pt.x == this.end.x && pt.y == this.end.y;
}

MazeGame.prototype.reset_origin = function()
{
    this.maze.setAttributeNS( null, "viewBox", this.origin );
}

MazeGame.prototype.maze_move = function( index, offset )
{
    var box = this.maze.getAttributeNS( null, "viewBox" ).split( ' ' );
    box[index] = +box[index] + offset;
    this.maze.setAttributeNS( null, "viewBox", box.join( ' ' ) );
}

MazeGame.prototype.up_blocked = function( pt )
{
    return (pt.y == 0 || this.board[pt.y-1][pt.x]);
}

MazeGame.prototype.left_blocked = function( pt )
{
    return pt.x < 0 || this.board[pt.y][pt.x-1] > 0;
}

MazeGame.prototype.right_blocked = function( pt )
{
    return pt.x+1 == this.board[pt.y].length
        || this.board[pt.y][pt.x+1] > 0;
}

MazeGame.prototype.down_blocked = function( pt )
{
    return pt.y+1 == this.board.length || this.board[pt.y+1][pt.x];
}

/***** Standalone functions *******/

function initialize( board, start, end, tile )
{
    game = new MazeGame( start, end, board );
    sprite = new Sprite( start, tile, game );
    
    sprite.reset();

    remove_msg();
}

function create_crumb_point( pt )
{
    var pos = sprite.calc_crumb_position( pt );
    return pos.x +  "," + pos.y;
}

function unshift(evt)
{
    if(16 == evt.keyCode)
    {
        shifted = false;
    }
}

function finished_msg()
{
    var msg = document.getElementById( "solvedmsg" );
    if(null == msg)
    {
        alert( "Solved!!" );
    }
    else
    {
        msg.setAttributeNS( null, "opacity", "1.0" );
        setTimeout( "remove_msg()", 2000 );
    }
}

function remove_msg()
{
    var msg = document.getElementById( "solvedmsg" );
    if(null != msg)
    {
        msg.setAttributeNS( null, "opacity", "0.0" );
    }
}

function restart()
{
    sprite.reset();
    sprite.show();
}

function make_visible( name )
{
    var elem = document.getElementById( name );
    if(null != elem)
    {
        elem.setAttributeNS( null, "visibility", "visible" );
    }
}

function maze_up()
{
    game.maze_move( 1, 25 );
}

function maze_down()
{
    game.maze_move( 1, -25 );
}

function maze_left()
{
    game.maze_move( 0, 25 );
}

function maze_right()
{
    game.maze_move( 0, -25 );
}

function maze_reset()
{
    game.reset_origin();
}

function save_position()
{
    sprite.save();
}

function restore_position()
{
    sprite.restore();
}
