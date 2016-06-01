class Player
{
    int maxHp;
    int hp;
    int str;
    int def;
    
    int level;
    int xp;
    
    Player()
    {
        hp = 100;
        str = 25;
        def = 25;
        
        level = 1;
        xp = 0;
        
        maxHp = hp * level;
    }
    
    void addXP( int amount )
    {
        xp += amount;
        
        if ( ( xp % 100 ) == 0 )
        {
            level++;
            
            hp = 100 * level;
            str *= level;
            def *= level;
            
            maxHp = hp * level;
        }
    } 
}
