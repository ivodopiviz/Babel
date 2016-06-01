import ddf.minim.*;

class EndingState extends State
{
    PImage background;
    AudioPlayer over;
    
    void init()
    {
        background = loadImage( "babel_gameover.png" );
        over = Babel.minim.loadFile( "over.wav" );
        over.play();
    }
    
    void handleKeys()
    {
        if ( keyPressed )
        {
            if ( key == ENTER )
                Babel.stateManager.switchState( StateManager.STATE_MENU, false );
        }
    }
    
    void draw()
    {
        background( 255, 255, 0 );
        text( "You journey has ended.", 400, 100 );
        
        image( background, 0, 0 );
        
        textFont( Babel.font, 24 );
        stroke( 255, 255, 255 );
        text( "Press ENTER to go back.", 400 + random( 1 ), 300 + random( 1 ) );
    }
}
