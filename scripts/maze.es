/**
 * File: maze.es
 *
 * Provide common interactive effects for a maze.
 */

var svgns = 'http://www.w3.org/2000/svg';
var xlinkns = 'http://www.w3.org/1999/xlink';
var delta;
var board;
var crumbpts;
var sprite;
var crumb;
var shifted = false;
var size;

var game;

/*
 * The MazeGame object will maintain the current state of the game and
 * update the display.
 */

function MazeGame( start, end )
{
    this.start = start;
    this.end = end;

    this.maze = document.getElementById( "maze" );
    this.origin = this.maze.getAttributeNS( null, "viewBox" );

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


/*
 * The Snapshots object holds and manipulates the stack of snapshot
 * positions.
 */

function Snapshots( maze )
{
    this.stack = [];
    this.maze = maze;
}

Snapshots.prototype.push = function( pt, pos, crumbpts )
{
    var mark = document.createElementNS( svgns, 'use' );

    mark.setAttributeNS( null, 'x', pos.x );
    mark.setAttributeNS( null, 'y', pos.y );
    mark.setAttributeNS( xlinkns, 'href', '#savemark' );

    this.maze.appendChild( mark );

    this.stack.push( { x: pt.x, y: pt.y, crumb: crumbpts, marker: mark } );
}

Snapshots.prototype.pop = function()
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
        this.pop();
    }
}


function initialize( board_, start_, end_, delta_ )
{
    game = new MazeGame( start_, end_ );
    board = board_;
    delta = delta_;
  
    sprite = document.getElementById( "me" );
    crumb  = document.getElementById( "crumb" );

    reset_sprite();
    remove_msg();
}

function calc_crumb_position( pt )
{
    return { x: pt.x*delta.x+delta.x/2,
             y: pt.y*delta.y+delta.y/2
           };
}

function create_crumb_point( pt )
{
    var pos = calc_crumb_position( pt );
    return pos.x +  "," + pos.y;
}

function reset_sprite()
{
    curr     = {x:game.start.x, y:game.start.y};
    crumbpts = create_crumb_point( game.start );
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

function show_sprite()
{
    sprite.setAttributeNS( null, "x", (curr.x*delta.x) );
    sprite.setAttributeNS( null, "y", (curr.y*delta.y) );

    crumbpts += " " + create_crumb_point( curr );
    crumb.setAttributeNS( null, "points", crumbpts );
}

function restart()
{
    game.saves.clear();

    reset_sprite();
    crumb.setAttributeNS( null, "points", crumbpts );

    show_sprite();
    sprite.setAttributeNS( null, "visibility", "visible" );

}

function make_visible( name )
{
    var elem = document.getElementById( name );
    if(null != elem)
    {
        elem.setAttributeNS( null, "visibility", "visible" );
    }
}

function maze_move( index, offset )
{
    var box = game.maze.getAttributeNS( null, "viewBox" ).split( ' ' );
    box[index] = +box[index] + offset;
    game.maze.setAttributeNS( null, "viewBox", box.join( ' ' ) );
}

function maze_up()
{
    maze_move( 1, 25 );
}

function maze_down()
{
    maze_move( 1, -25 );
}

function maze_left()
{
    maze_move( 0, 25 );
}

function maze_right()
{
    maze_move( 0, -25 );
}

function maze_reset()
{
    game.reset_origin();
}

function save_position()
{
    var pos = calc_crumb_position( curr );

    game.saves.push( curr, pos, crumbpts );
}

function restore_position()
{
    if(!game.saves.empty())
    {
        var saved = game.saves.pop();
        curr.x = saved.x;
        curr.y = saved.y;
        crumbpts = saved.crumb;
        show_sprite();
    }
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

