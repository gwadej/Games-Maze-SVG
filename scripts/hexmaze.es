/**
 * File: hexmaze.es
 *
 * Provide interactive effects for a hexagonal maze.
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

  make_visible( "exit" );  
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
    case 16:
        shifted = true;
	return;
    case 40: // down
       while(move_down() && shifted)
           show_sprite();
       break;
    case 38: // up
       while(move_up() && shifted)
           show_sprite();
       break;
    case 37: // left
       while((move_left()||move_upleft()||move_dnleft()) && shifted)
           show_sprite();
       break;
    case 39: // right
       while((move_right()||move_upright()||move_dnright()) && shifted)
           show_sprite();
       break;
    default:
       return;
   }
  show_sprite();
  if((curr.x == end.x || curr.x+1 == end.x)&& curr.y == end.y)
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
  if(curr.y+1 == board.length || board[curr.y][curr.x]
     || board[curr.y+1][curr.x] > 0
    )
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
  if(curr.x < 0 || board[curr.y][curr.x-1] > 0)
   {
    return false;
   }
  curr.x--;
  return true;
 }

function move_right()
 {
  if(curr.x+1 == board[curr.y].length || board[curr.y][curr.x+1] > 0)
   {
    return false;
   }
  curr.x++;
  return true;
 }

function move_dnleft()
 {
  if(curr.x < 0 || curr.y+1 == board.length
    || board[curr.y+1][curr.x-1] > 0
    || board[curr.y][curr.x]
    || board[curr.y][curr.x-1] == -1
    )
   {
    return false;
   }
  curr.x--;
  curr.y++;
  return true;
 }

function move_upleft()
 {
  if(curr.x < 0 || curr.y < 0 || board[curr.y-1][curr.x-1]
     || (board[curr.y][curr.x-1] && board[curr.y-1][curr.x]))
   {
    return false;
   }
  curr.x--;
  curr.y--;
  return true;
 }

function move_dnright()
 {
  if(curr.y+1 == board.length
    || curr.x+1 == board[curr.y+1].length
    || board[curr.y][curr.x]
    || board[curr.y][curr.x+1] == -1
    || board[curr.y+1][curr.x+1] > 0)
   {
    return false;
   }
  curr.x++;
  curr.y++;
  return true;
 }

function move_upright()
 {
  if(curr.y < 0 || curr.x+1 == board[curr.y-1].length
    || board[curr.y-1][curr.x+1]
    || (board[curr.y][curr.x+1] && board[curr.y-1][curr.x]))
   {
    return false;
   }
  curr.x++;
  curr.y--;
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

function make_visible( name )
{
    var elem = document.getElementById( name );
     if(null != elem)
     {
          elem.setAttributeNS( null, "visibility", "visible" );
     }
}
