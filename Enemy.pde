class Enemy
{
    final static int TYPE_ABSTRACTION = 0;
    final static int TYPE_CALCINATION = 1;
    final static int TYPE_COAGULATION = 2;
    final static int TYPE_COMPOSITION = 3;
    
    int type;
    
    int hp;
    int str;
    int def;
    
    PImage image;
    
    Enemy( int newType, int level )
    {
        switch( newType )
        {
            case TYPE_ABSTRACTION:
                image = loadImage( "abstraction.png" );
                hp = 37;
                str = 50;
                def = 25;
                break;
            
            case TYPE_CALCINATION:
                image = loadImage( "calcination.png" );
                hp = 12;
                str = 37;
                def = 7;
                break;
                
            case TYPE_COAGULATION:
                image = loadImage( "coagulation.png" );
                str = 12;
                hp = 25;
                def = 25;
                break;
                
            case TYPE_COMPOSITION:
                image = loadImage( "composition.png" );
                hp = 17;
                str = 17;
                def = 12;
                break;
        }
        
        hp += 5 * level;
        str += 5 * level;
        def += 5 * level;
    }
}

