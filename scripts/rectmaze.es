/**
 * File: rectmaze.es
 *
 * Provide interactive effects for a rectangular maze.
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

function initialize( board_, start_, end_, delta_ )
 {
  board = board_;
  start = start_;
  end   = end_;
  delta = delta_;
  
  sprite = document.getElementById( "me" );
  crumb  = document.getElementById( "crumb" );

  reset_sprite();
  remove_msg();
 }

function reset_sprite()
 {
  curr     = {x:start.x, y:start.y};
  crumbpts = (start.x*delta.x + delta.x/2) + ",0";
 }

function unshift(evt)
{
    if(16 == evt.keyCode)
    {
        shifted = false;
    }
}

function move_sprite(evt)
 {
  switch(evt.keyCode)
   {
    case 16: // shift
        shifted = true;
	return;
    case 40: // down
       while(move_down() && shifted);
       break;
    case 38: // up
       while(move_up() && shifted);
       break;
    case 37:
       while(move_left() && shifted);
       break;
    case 39: // right
       while(move_right() && shifted);
       break;
    case 66: // 'b'
       restart();
       return;
    default:
       return;
   }
  show_sprite();
  if(curr.x == end.x && curr.y == end.y)
   {
    setTimeout( "finished_msg()", 10 );
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

function move_down()
 {
  if(curr.y+1 == board.length || board[curr.y+1][curr.x])
   {
    return false;
   }
  curr.y++;
  return true;
 }

function move_up()
 {
  if(curr.y == 0 || board[curr.y-1][curr.x])
   {
    return false;
   }
  curr.y--;
  return true;
 }

function move_left()
 {
  if(curr.x < 0 || board[curr.y][curr.x-1])
   {
    return false;
   }
  curr.x--;
  return true;
 }

function move_right()
 {
  if(curr.x+1 == board[curr.y].length || board[curr.y][curr.x+1])
   {
    return false;
   }
  curr.x++;
  return true;
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
