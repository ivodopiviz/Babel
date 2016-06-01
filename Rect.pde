class Rect
{
    int x1, y1, x2, y2;
    int centerX, centerY;
    
    Rect( int x, int y, int w, int h )
    {
        x1 = x;
        y1 = y;
        x2 = x + w;
        y2 = y + h;
    }
    
    int[] center()
    {
        int[] result = new int[2];
        
        centerX = ( x1 + x2) / 2;
        centerY = ( y1 + y2) / 2;
        
        result[0] = centerX;
        result[1] = centerY;
        
        return result;
    }
    
    boolean intersects( Rect other )
    {
        return ( x1 <= other.x2 && x2 >= other.x1 &&
                y1 <= other.y2 && y2 >= other.y1 );    
    }
}
