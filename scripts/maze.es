/**
 * File: maze.es
 *
 * Provide common interactive effects for a maze.
 */

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
