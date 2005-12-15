/**
 * File: maze.es
 *
 * Provide common interactive effects for a maze.
 */

var shifted = false;

var game;
var sprite;
var extents;

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
    return (pt.y == 0 || this.board[pt.y-1][pt.x]-0);
}

MazeGame.prototype.left_blocked = function( pt )
{
    return pt.x < 0 || this.board[pt.y][pt.x-1]-0 > 0;
}

MazeGame.prototype.right_blocked = function( pt )
{
    return pt.x+1 == this.board[pt.y].length
        || this.board[pt.y][pt.x+1]-0 > 0;
}

MazeGame.prototype.down_blocked = function( pt )
{
    return pt.y+1 == this.board.length || this.board[pt.y+1][pt.x]-0;
}

/***** Standalone functions *******/

function initialize()
{
    var mazedesc = loadBoard();

    game = new MazeGame( mazedesc.start, mazedesc.end, mazedesc.board );
    sprite = new Sprite( mazedesc.start, mazedesc.tile, game );
    
    sprite.reset();

    remove_msg();

    extents = getDisplaySize();
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

function  setText(elem, str)
 {
   var text = document.createTextNode( str );
   elem.replaceChild( text, elem.getFirstChild() );
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
    game.maze_move( 1, -25 );
}

function maze_down()
{
    game.maze_move( 1, 25 );
}

function maze_left()
{
    game.maze_move( 0, -25 );
}

function maze_right()
{
    game.maze_move( 0, 25 );
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

function getDisplaySize()
{
    var extents = null;
    try
    {
        var view = document.documentElement.viewport;

        extents = {
            width: view.width,
            height: view.height
        };
    }
    catch(e)
    {
        extents = {
            width: window.innerWidth,
            height: window.innerHeight
        };
    }

    return extents;
}

function loadBoard()
{
    var elem = document.getElementsByTagNameNS( "http://www.anomaly.org/2005/maze",
        "board" ).item( 0 );

    var content = elem.childNodes.item( 0 ).nodeValue;

    // if the content is broken up for some reason.
    for(var i = 1;i < elem.childNodes.length;++i)
    {
        content = content + elem.childNodes.item( i ).nodeValue;
    }

    var lines = content.split( /\s+/ );
    var retval = {
        board: [],
	start: { x: 0, y: 0 },
	end: { x: 0, y: 0 },
	tile: { x: 0, y: 0 }
    };

    for(var i=0, j=0;i < lines.length;++i)
    {
        lines[i].replace( /\s+/g, '' );
	if(lines[i].length)
	{
	    retval.board[j++] = lines[i].split( '' );
	}
    }
    
    retval.start = pointFromAttribute( elem, "start" );
    retval.end = pointFromAttribute( elem, "end" );
    retval.tile = pointFromAttribute( elem, "tile" );
    
    return retval;
}


function pointFromAttribute( elem, attr )
{
    var value = elem.getAttributeNS( null, attr );
    if(null == value)
    {
        return null;
    }

    var parts = value.split( /[, ]+/ );
    if(2 > parts.length)
    {
        return null;
    }

    return { x: parts[0]-0, y: parts[1]-0 };
}
