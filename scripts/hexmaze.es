/**
 * File: hexmaze.es
 *
 * Provide interactive effects for a hexagonal maze.
 * Depends on maze.es for support.
 */

function move_sprite(evt)
{
  switch(evt.keyCode)
   {
    case 16:
        shifted = true;
	return;
    case 40: // down
       while(move_down() && shifted);
       break;
    case 38: // up
       while(move_up() && shifted);
       break;
    case 37: // left
       while((move_left()||move_upleft()||move_dnleft()) && shifted);
       break;
    case 39: // right
       while((move_right()||move_upright()||move_dnright()) && shifted);
       break;
    case 98: // 'b'
    case 66: // 'B'
       restart();
       return;
    case 115: // 's'
    case 83: // 'S'
       save_position();
       return;
    case 114: // 'r'
    case 82: // 'R'
       restore_position();
       return;
    default:
       return;
   }

    game.show_sprite();
    if(game.isFinished( curr ))
    {
        setTimeout( "finished_msg()", 10 );
    }
}

MazeGame.prototype.isFinished = function( pt )
{
    return (pt.x == this.end.x || pt.x+1 == this.end.x) && pt.y == this.end.y;
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
  if(up_blocked())
   {
    return false;
   }
  curr.y--;
  return true;
 }

function move_left()
 {
  if(left_blocked())
   {
    return false;
   }
  curr.x--;
  return true;
 }

function move_right()
 {
  if(right_blocked())
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

