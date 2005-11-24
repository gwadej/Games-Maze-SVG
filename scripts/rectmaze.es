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
	   while(move_down() && shifted)
               ;
	   break;
	case 38: // up
	   while(move_up() && shifted)
               ;
	   break;
	case 37:
	   while(move_left() && shifted)
               ;
	   break;
	case 39: // right
	   while(move_right() && shifted)
               ;
	   break;
	default:
	   return;
    }
    game.show_sprite();

    if(game.isFinished( curr ))
    {
        setTimeout( "finished_msg()", 10 );
    }
}

function move_down()
{
    if(game.down_blocked( curr ))
    {
         return false;
    }
    curr.y++;
    return true;
}

function move_up()
{
    if(game.up_blocked( curr ))
    {
        return false;
    }
    curr.y--;
    return true;
}

function move_left()
{
    if(game.left_blocked( curr ))
    {
        return false;
    }
    curr.x--;
    return true;
}

function move_right()
{
    if(game.right_blocked( curr ))
    {
        return false;
    }
    curr.x++;
    return true;
}
