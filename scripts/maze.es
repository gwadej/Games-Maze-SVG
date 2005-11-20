/**
 * File: maze.es
 *
 * Provide common interactive effects for a maze.
 */

var svgns = 'http://www.w3.org/2000/svg';
var xlinkns = 'http://www.w3.org/1999/xlink';
var start;
var end;
var delta;
var end;
var board;
var crumbpts;
var sprite;
var crumb;
var shifted = false;
var maze;
var origin;
var size;
var saves = [];

function initialize( board_, start_, end_, delta_ )
{
    board = board_;
    start = start_;
    end   = end_;
    delta = delta_;
  
    sprite = document.getElementById( "me" );
    crumb  = document.getElementById( "crumb" );
    maze   = document.getElementById( "maze" );
    origin = maze.getAttributeNS( null, "viewBox" ).split( ' ' );

    reset_sprite();
    remove_msg();
}

function reset_sprite()
{
    curr     = {x:start.x, y:start.y};
    crumbpts = (start.x*delta.x + delta.x/2) + "," + start.y*delta.y;
    saves = [];
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

    crumbpts += " " + (curr.x*delta.x+delta.x/2)
             +  "," + (curr.y*delta.y+delta.y/2);
    crumb.setAttributeNS( null, "points", crumbpts );
}

function restart()
{
    for(var i=0;i < saves.length;++i)
    {
        maze.removeChild( saves[i].marker );
    }

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

function maze_up()
{
    var box = maze.getAttributeNS( null, "viewBox" ).split( ' ' );
    box[1] = +box[1] - 25;
    maze.setAttributeNS( null, "viewBox", box.join( ' ' ) );
}

function maze_down()
{
    var box = maze.getAttributeNS( null, "viewBox" ).split( ' ' );
    box[1] = +box[1] + 25;
    maze.setAttributeNS( null, "viewBox", box.join( ' ' ) );
}

function maze_left()
{
    var box = maze.getAttributeNS( null, "viewBox" ).split( ' ' );
    box[0] = +box[0] - 25;
    maze.setAttributeNS( null, "viewBox", box.join( ' ' ) );
}

function maze_right()
{
    var box = maze.getAttributeNS( null, "viewBox" ).split( ' ' );
    box[0] = +box[0] + 25;
    maze.setAttributeNS( null, "viewBox", box.join( ' ' ) );
}

function maze_reset()
{
    maze.setAttributeNS( null, "viewBox", origin.join( ' ' ) );
}

function save_position()
{
    var mark = document.createElementNS( svgns, 'use' );
    mark.setAttributeNS( null, 'x', curr.x*delta.x+delta.x/2 );
    mark.setAttributeNS( null, 'y', curr.y*delta.y+delta.y/2 );
    mark.setAttributeNS( xlinkns, 'href', '#savemark' );
    maze.appendChild( mark );

    saves.push( { x: curr.x, y: curr.y, crumb: crumbpts, marker: mark } );
}

function restore_position()
{
    if(saves.length)
    {
        var saved = saves.pop();
        curr.x = saved.x;
        curr.y = saved.y;
        crumbpts = saved.crumb;
	maze.removeChild( saved.marker );
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

