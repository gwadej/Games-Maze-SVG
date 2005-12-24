/*
 * File: sprite.es
 * Encapsulate the concept of the sprite that represents us into an object.
 */
 
var svgns = 'http://www.w3.org/2000/svg';
var xlinkns = 'http://www.w3.org/1999/xlink';

function Sprite( start, tile, game )
{
    this.start = start;
    this.tile = tile;
    this.game = game;

    this.saves = new Snapshots( this.game.maze );

    this.elem = document.getElementById( "me" );
    this.crumb = document.getElementById( "crumb" );
}

Sprite.prototype.reset = function()
{
    this.curr     = this.start.clone();
    this.crumbpts = create_crumb_point( this.start );
    this.crumb.setAttributeNS( null, "points", this.crumbpts );
    this.saves.clear();
}

Sprite.prototype.show = function()
{
    this.elem.setAttributeNS( null, "x", (this.curr.x*this.tile.x) );
    this.elem.setAttributeNS( null, "y", (this.curr.y*this.tile.y) );
    this.elem.setAttributeNS( null, "visibility", "visible" );

    this.crumbpts += " " + create_crumb_point( this.curr );
    this.crumb.setAttributeNS( null, "points", this.crumbpts );
}

Sprite.prototype.calc_crumb_position = function( pt )
{
    return new Point( pt.x*this.tile.x+this.tile.x/2,
                      pt.y*this.tile.y+this.tile.y/2
                    );
}

Sprite.prototype.save = function()
{
    var pos = this.calc_crumb_position( this.curr );

    this.saves.save( this.curr, pos, this.crumbpts );
}

Sprite.prototype.restore = function()
{
    if(!this.saves.empty())
    {
        var saved = this.saves.last();
	this.curr = saved.pt.clone();
        this.crumbpts = saved.crumb;
        this.show();
    }
}

Sprite.prototype.move_down = function()
{
    if(this.game.down_blocked( this.curr ))
    {
         return false;
    }
    this.curr.y++;
    return true;
}

Sprite.prototype.move_up = function()
{
    if(this.game.up_blocked( this.curr ))
    {
        return false;
    }
    this.curr.y--;
    return true;
}

Sprite.prototype.move_left = function()
{
    if(this.game.left_blocked( this.curr ))
    {
        return false;
    }
    this.curr.x--;
    return true;
}

Sprite.prototype.move_right = function()
{
    if(this.game.right_blocked( this.curr ))
    {
        return false;
    }
    this.curr.x++;
    return true;
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

Snapshots.prototype.save = function( pt, pos, crumbpts )
{
    var mark = document.createElementNS( svgns, 'use' );

    positionElement( mark, pos );
    mark.setAttributeNS( xlinkns, 'href', '#savemark' );

    this.maze.appendChild( mark );

    this.stack.push( { pt: pt.clone(), crumb: crumbpts, marker: mark } );
}

Snapshots.prototype.last = function()
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
        this.last();
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

