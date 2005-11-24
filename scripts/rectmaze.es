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
	   while(sprite.move_down() && shifted)
               ;
	   break;
	case 38: // up
	   while(sprite.move_up() && shifted)
               ;
	   break;
	case 37:
	   while(sprite.move_left() && shifted)
               ;
	   break;
	case 39: // right
	   while(sprite.move_right() && shifted)
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
