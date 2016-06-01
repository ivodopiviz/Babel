class DungeonMap
{
    final int mapWidth = 80;
    final int mapHeight = 45;
    
    final int roomMaxSize = 12;
    final int roomMinSize = 8;
    int maxRooms = 5;
    
    Tile[][] tileMap;
    Rect[] rooms;
    int numRooms;
    
    int startX = 0;
    int startY = 0;
    
    int exitX = 0;
    int exitY = 0;
    
    boolean exitExists = false;
    
    void init( int floor)
    {
        println( "DungeonMap Init" );
        tileMap = new Tile[mapWidth][mapHeight];
        
        for( int i = 0; i < mapWidth; i++ )
        {
            for( int j = 0; j < mapHeight; j++ )
            {
                tileMap[i][j] = new Tile( true, true );
            }
        }
        maxRooms += floor;
        rooms = new Rect[maxRooms];
        numRooms = 0;
        
        for( int r = 0; r < maxRooms; r++ )
        {
            int w = (int) random( roomMinSize, roomMaxSize );
            int h = (int) random( roomMinSize, roomMaxSize );

            int x = (int) random( 0, mapWidth - w - 1 );
            int y = (int) random( 0, mapHeight - h - 1 );
            
            Rect newRoom = new Rect( x, y, w, h );
            
            boolean failed = false;

            for ( int roomIndex = 0; roomIndex < rooms.length; roomIndex++ )
            {
                Rect otherRoom = rooms[roomIndex];
                if ( otherRoom != null )
                {
                    if ( newRoom.intersects( otherRoom ) )
                    {
                       failed = true;
                       break;
                    }
                }
            }
            
            if ( !failed )
            {
                createRoom( newRoom );
                
                int[] center = newRoom.center();
                int newX, newY;
                
                newX = center[0];
                newY = center[1];
                
                if ( numRooms == 0 )
                {
                    startX = newX;
                    startY = newY;
                }
                else
                {
                    int[] prevCenter = rooms[numRooms - 1].center();
                    int prevX = prevCenter[0];
                    int prevY = prevCenter[1];
                    
                    if ( int( random( 1 ) ) == 1 )
                    {
                        createHTunnel( prevX, newX, prevY );
                        createVTunnel( prevY, newY, newX );
                    } 
                    else
                    {
                        createVTunnel( prevY, newY, prevX );
                        createHTunnel( prevX, newX, newY );
                    }
                }
                
                rooms[numRooms] = newRoom;
                numRooms++;
            }
        }
        
        if ( !exitExists )
        {
            println( "Set up exit point" );
            int[] lastCenter = rooms[numRooms - 1].center();
            int exitX = lastCenter[0];
            int exitY = lastCenter[1];
            
            tileMap[exitX][exitY].blocked = false;
            tileMap[exitX][exitY].blockSight = true;
            tileMap[exitX][exitY].exits = true;
                
            exitExists = true;
        }
    }
    
    void createRoom( Rect rect )
    {
        for( int i = rect.x1 + 1; i < rect.x2; i++ )
        {
            for( int j = rect.y1 + 1; j < rect.y2; j++ )
            {
                tileMap[i][j].blocked = false;
                tileMap[i][j].blockSight = false;
            }
        }
    }
    
    void createHTunnel( int x1, int x2, int y )
    {
        for ( int x = min( x1, x2 ); x < max( x1, x2) + 1; x++ )
        {
            tileMap[x][y].blocked = false;
            tileMap[x][y].blockSight = false;
        }
    }
    
    void createVTunnel( int y1, int y2, int x )
    {
        for ( int y = min( y1, y2 ); y < max( y1, y2) + 1; y++ )
        {
            tileMap[x][y].blocked = false;
            tileMap[x][y].blockSight = false;
        }
    } 
}
