/**
 * File: maze.es
 *
 * Provide common interactive effects for a maze.
 */

var svgns = 'http://www.w3.org/2000/svg';
var xlinkns = 'http://www.w3.org/1999/xlink';
var shifted = false;

var game;
var sprite;

/*
 * The MazeGame object will maintain the current state of the game and
 * update the display.
 */

function MazeGame( start, end, tile, board )
{
    this.start = start;
    this.end = end;
    this.tile = tile;
    this.board = board;

    this.maze = document.getElementById( "maze" );
    this.origin = this.maze.getAttributeNS( null, "viewBox" );
    this.crumb  = document.getElementById( "crumb" );

    this.saves = new Snapshots( this.maze );
}

MazeGame.prototype.isFinished = function( pt )
{
    return pt.x == this.end.x && pt.y == this.end.y;
}

MazeGame.prototype.reset_origin = function()
{
    this.maze.setAttributeNS( null, "viewBox", this.origin );
}

MazeGame.prototype.calc_crumb_position = function( pt )
{
    return { x: pt.x*this.tile.x+this.tile.x/2,
             y: pt.y*this.tile.y+this.tile.y/2
           };
}

MazeGame.prototype.maze_move = function( index, offset )
{
    var box = this.maze.getAttributeNS( null, "viewBox" ).split( ' ' );
    box[index] = +box[index] + offset;
    this.maze.setAttributeNS( null, "viewBox", box.join( ' ' ) );
}

/*
 * Encapsulate the concept of the sprite that represents us.
 */
function Sprite( start, tile, game )
{
    this.start = start;
    this.tile = tile;
    this.game = game;
    this.curr = start;

    this.elem = document.getElementById( "me" );
}

Sprite.prototype.reset = function()
{
    this.curr     = {x:this.start.x, y:this.start.y};
    game.crumbpts = create_crumb_point( this.start );
}

Sprite.prototype.show = function()
{
    this.elem.setAttributeNS( null, "x", (this.curr.x*this.tile.x) );
    this.elem.setAttributeNS( null, "y", (this.curr.y*this.tile.y) );
    this.elem.setAttributeNS( null, "visibility", "visible" );

    this.game.crumbpts += " " + create_crumb_point( this.curr );
    this.game.crumb.setAttributeNS( null, "points", this.game.crumbpts );
}

/*
 * The Snapshots object holds and manipulates the stack of snapshot
 * positions.
 */

function Snapshots( maze )
{
    this.stack = [];
    this.maze = maze;
}

Snapshots.prototype.save = function( pt, pos, crumbpts )
{
    var mark = document.createElementNS( svgns, 'use' );

    mark.setAttributeNS( null, 'x', pos.x );
    mark.setAttributeNS( null, 'y', pos.y );
    mark.setAttributeNS( xlinkns, 'href', '#savemark' );

    this.maze.appendChild( mark );

    this.stack.push( { x: pt.x, y: pt.y, crumb: crumbpts, marker: mark } );
}

Snapshots.prototype.last = function()
{
    var item = this.stack.pop();

    this.maze.removeChild( item.marker );

    return item;
}

Snapshots.prototype.empty = function()
{
    return 0 == this.stack.length;
}

Snapshots.prototype.clear = function()
{
    while(!this.empty())
    {
        this.last();
    }
}

/***** Standalone functions *******/

function initialize( board, start, end, tile )
{
    game = new MazeGame( start, end, tile, board );
    sprite = new Sprite( start, tile, game );

    sprite.reset();
    remove_msg();
}

function create_crumb_point( pt )
{
    var pos = game.calc_crumb_position( pt );
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

MazeGame.prototype.show_sprite = function()
{
    sprite.show();
}

function restart()
{
    game.saves.clear();

    sprite.reset();
    game.crumb.setAttributeNS( null, "points", game.crumbpts );

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
    var pos = game.calc_crumb_position( sprite.curr );

    game.saves.save( sprite.curr, pos, game.crumbpts );
}

function restore_position()
{
    if(!game.saves.empty())
    {
        var saved = game.saves.last();
        sprite.curr.x = saved.x;
        sprite.curr.y = saved.y;
        game.crumbpts = saved.crumb;
        sprite.show();
    }
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


/*
 * Patch array handling for ASV which is missing these useful methods.
 */

/** Add missing Array.push().
 */
try
{
    var arr = new Array();
    arr.push( 1 );
}
catch(ex)
{
    function _array_push( item )
    {
        var args = _array_push.arguments;
    
        for(var i=0;i < args.length;++i)
            this[this.length++] = args[i];

        return this.length;
    }
    Array.prototype.push = _array_push;
}


/** Add missing Array.pop().
 */
try
{
    var arr = [ 1, 2 ];
    arr.pop();
}
catch(ex)
{
    function _array_pop()
    {
        if(0 == this.length)
	    return null;

        var ret = this[this.length-1];
	this.length--;

        return ret;
    }
    Array.prototype.pop = _array_pop;
}

