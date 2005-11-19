/**
 * File: rectmaze.es
 *
 * Provide interactive effects for a rectangular maze.
 * Depends on maze.es for support.
 */

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
