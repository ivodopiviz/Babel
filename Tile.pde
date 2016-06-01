class Tile
{
    boolean blocked;
    boolean blockSight;
    boolean exits;
    
    Tile( boolean b, boolean bs )
    {
        blocked = b;
        blockSight = bs;
        exits = false;
    } 
}
