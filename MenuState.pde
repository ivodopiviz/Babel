import ddf.minim.*;

class MenuState extends State
{
    PImage background;
    AudioPlayer intro;
    
    void init()
    {
        background = loadImage( "babel_menu.png" );
        intro = Babel.minim.loadFile( "start.wav" );
    }
    
    void handleKeys()
    {
        if ( keyPressed )
        {
            if ( key == ENTER )
            {
                Babel.stateManager.switchState( StateManager.STATE_DUNGEON, false );
                intro.play();
            }
        }
    }
    
    void draw()
    {
        image( background, 0, 0 );
        
        textFont( Babel.font, 24 );
        stroke( 255, 255, 255 );
        text( "Press ENTER to play.", 400 + random( 3 ), 300 + random( 3 ) );

        textFont( Babel.fontHUD, 14 );
        text( "Made for Ludum Dare #26 - 2013", 10, 590 );
    }
}
