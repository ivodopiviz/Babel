class Raycaster
{ 
    DungeonMap dungeonMap;
    
    float posX = 25;
    float posY = 23;
    
    float dirX = -1;
    float dirY = 0;
    
    float planeX = 0;
    float planeY = 0.66;
    
    float time = 0;
    float oldTime = 0;
    
    int currentFloor = 0;

    int renderAlpha = 255;

    void init()
    {
        println( "Raycaster Init " +  currentFloor );
        
        dungeonMap = new DungeonMap();
        dungeonMap.init( currentFloor );
        posX = dungeonMap.startX;
        posY = dungeonMap.startY;
    }
    
    void update()
    {
        // implement this
    }
    
    void draw()
    {
        for(int x = 0; x < 800; x++)
        {
            float cameraX = 2 * x / (float) 800 - 1; //x-coordinate in camera space
            float rayPosX = posX;
            float rayPosY = posY;
            float rayDirX = dirX + planeX * cameraX;
            float rayDirY = dirY + planeY * cameraX;

            int mapX = ( int )rayPosX;
            int mapY = ( int )rayPosY;

            float sideDistX;
            float sideDistY;

            float deltaDistX = sqrt( 1 + ( rayDirY * rayDirY ) / ( rayDirX * rayDirX ) );
            float deltaDistY = sqrt( 1 + ( rayDirX * rayDirX ) / ( rayDirY * rayDirY ) );
            float perpWallDist;

            int stepX;
            int stepY;

            int hit = 0;
            int side = 0;
          
            if ( rayDirX < 0 )
            {
                stepX = -1;
                sideDistX = (rayPosX - mapX) * deltaDistX;
            }
            else
            {
                stepX = 1;
                sideDistX = (mapX + 1.0 - rayPosX) * deltaDistX;
            }

            if (rayDirY < 0)
            {
                stepY = -1;
                sideDistY = (rayPosY - mapY) * deltaDistY;
            }
            else
            {
                stepY = 1;
                sideDistY = (mapY + 1.0 - rayPosY) * deltaDistY;
            }
          
            while (hit == 0)
            {
                if (sideDistX < sideDistY)
                {
                    sideDistX += deltaDistX;
                    mapX += stepX;
                    side = 0;
                }
                else
                {
                    sideDistY += deltaDistY;
                    mapY += stepY;
                    side = 1;
                }

                if ( dungeonMap.tileMap[mapX][mapY].blocked ) hit = 1;
                if ( dungeonMap.tileMap[mapX][mapY].blockSight ) hit = 1;
            }
          
            if (side == 0)
                perpWallDist = abs((mapX - rayPosX + (1 - stepX) / 2) / rayDirX);
            else
                perpWallDist = abs((mapY - rayPosY + (1 - stepY) / 2) / rayDirY);
          
            int lineHeight = abs(int(600 / perpWallDist));
          
            int drawStart = -lineHeight / 2 + 600 / 2;
            if(drawStart < 0)drawStart = 0;
            int drawEnd = lineHeight / 2 + 600 / 2;
            if(drawEnd >= 600)drawEnd = 600 - 1;
            
            color wallColor = color( 0, 0, 255 );
            if ( dungeonMap.tileMap[mapX][mapY].blocked )
                //wallColor = color( 0, 0, 255 );
                wallColor = color( 232, 146, 146 );
              
            if ( dungeonMap.tileMap[mapX][mapY].exits )
                wallColor = color( 0, 176, 246 );
          
            if (side == 1) {wallColor = color( red(wallColor) / 2, green(wallColor) / 2, blue(wallColor) / 2 );}
    
            stroke( wallColor, renderAlpha );
            line( x, drawStart, x, drawEnd );
        }
    }
    
    void moveForward()
    {
        if ( dungeonMap.tileMap[int(posX + dirX * 0.5)][int(posY)].exits )
        {
            changeFloor();
        }
        
        if ( !dungeonMap.tileMap[int(posX + dirX * 0.5)][int(posY)].blocked ) posX += dirX * 0.5;
        if ( !dungeonMap.tileMap[int(posX)][int(posY + dirY * 0.5)].blocked ) posY += dirY * 0.5;
    }
    
    void moveBackwards()
    {
        if ( !dungeonMap.tileMap[int(posX - dirX * 0.5)][int(posY)].blocked ) posX -= dirX * 0.5;
        if ( !dungeonMap.tileMap[int(posX)][int(posY - dirY * 0.5)].blocked ) posY -= dirY * 0.5;
    }

    void rotateLeft()
    {
        float oldDirX = dirX;
        float rotSpeed = 0.1;
        
        dirX = dirX * cos(rotSpeed) - dirY * sin(rotSpeed);
        dirY = oldDirX * sin(rotSpeed) + dirY * cos(rotSpeed);
        float oldPlaneX = planeX;
        planeX = planeX * cos(rotSpeed) - planeY * sin(rotSpeed);
        planeY = oldPlaneX * sin(rotSpeed) + planeY * cos(rotSpeed);
    }

    void rotateRight()
    {
        float oldDirX = dirX;
        float rotSpeed = 0.1;
        
        dirX = dirX * cos(-rotSpeed) - dirY * sin(-rotSpeed);
        dirY = oldDirX * sin(-rotSpeed) + dirY * cos(-rotSpeed);
        float oldPlaneX = planeX;
        planeX = planeX * cos(-rotSpeed) - planeY * sin(-rotSpeed);
        planeY = oldPlaneX * sin(-rotSpeed) + planeY * cos(-rotSpeed);
    }    
    
    void changeFloor()
    {
        //println( "Changing floor" );
        currentFloor++;
        
        if ( currentFloor == 8 )
            return;

        init();
    }   
}
