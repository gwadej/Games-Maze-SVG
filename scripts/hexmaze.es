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
	   while(move_down() && shifted)
	       ;
	   break;
	case 38: // up
	   while(move_up() && shifted)
	       ;
	   break;
	case 37: // left
	   while((move_left()||move_upleft()||move_dnleft()) && shifted)
	       ;
	   break;
	case 39: // right
	   while((move_right()||move_upright()||move_dnright()) && shifted)
	       ;
	   break;
	default:
	   return;
    }

    sprite.show();
    if(game.isFinished( sprite.curr ))
    {
        setTimeout( "finished_msg()", 10 );
    }
}

MazeGame.prototype.isFinished = function( pt )
{
    return (pt.x == this.end.x || pt.x+1 == this.end.x) && pt.y == this.end.y;
}

/* Override for a hex maze */
MazeGame.prototype.down_blocked = function( pt )
{
    return pt.y+1 == this.board.length
        || this.board[pt.y][pt.x]
        || this.board[pt.y+1][pt.x] > 0;
}

/* Add some methods for the hex maze */
MazeGame.prototype.downright_blocked = function( pt )
{
    return pt.y+1 == this.board.length
        || pt.x+1 == this.board[pt.y+1].length
        || this.board[pt.y][pt.x]
        || this.board[pt.y][pt.x+1] == -1
        || this.board[pt.y+1][pt.x+1] > 0;
}

MazeGame.prototype.downleft_blocked = function( pt )
{
    return pt.x < 0 || pt.y+1 == this.board.length
        || this.board[pt.y+1][pt.x-1] > 0
        || this.board[pt.y][pt.x]
        || this.board[pt.y][pt.x-1] == -1;
}

MazeGame.prototype.upright_blocked = function( pt )
{
    return pt.y < 0 || pt.x+1 == this.board[pt.y-1].length
    || this.board[pt.y-1][pt.x+1]
    || (this.board[pt.y][pt.x+1] && this.board[pt.y-1][pt.x]);
}

MazeGame.prototype.upleft_blocked = function( pt )
{
    return pt.x < 0 || pt.y < 0 || this.board[pt.y-1][pt.x-1]
     || (this.board[pt.y][pt.x-1] && this.board[pt.y-1][pt.x]);
}



function move_down()
{
    if(game.down_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.y++;
    return true;
}

function move_up()
{
    if(game.up_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.y--;
    return true;
}

function move_left()
{
    if(game.left_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.x--;
    return true;
}

function move_right()
{
    if(game.right_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.x++;
    return true;
}

function move_dnleft()
{
    if(game.downleft_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.x--;
    sprite.curr.y++;
    return true;
}

function move_upleft()
{
    if(game.upleft_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.x--;
    sprite.curr.y--;
    return true;
}

function move_dnright()
{
    if(game.downright_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.x++;
    sprite.curr.y++;
    return true;
}

function move_upright()
{
    if(game.upright_blocked( sprite.curr ))
    {
        return false;
    }
    sprite.curr.x++;
    sprite.curr.y--;
    return true;
}
