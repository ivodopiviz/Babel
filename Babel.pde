// Babel
import ddf.minim.*;

static StateManager stateManager;
static PFont font;
static PFont fontHUD;

static Minim minim;
//static AudioPlayer player;

void setup()
{
    size( 800, 600 );
    frameRate( 30 );
    minim = new Minim( this );
    
    font = loadFont( "Sreda-48.vlw" );
    fontHUD = loadFont( "Signika-Regular-24.vlw" );

    stateManager = new StateManager();
    stateManager.switchState( StateManager.STATE_MENU, false );
    //stateManager.switchState( StateManager.STATE_DUNGEON, false );
    //stateManager.switchState( StateManager.STATE_ENDING, false );
}

void mousePressed()
{
    if ( stateManager.currentState != null )
        stateManager.currentState.handleMouse();
}

void draw()
{
    //if ( stateManager.currentState != null )
    //{
    //    stateManager.currentState.handleKeys();
    //    stateManager.currentState.update();
    //    stateManager.currentState.draw();  
    //}

    stateManager.currentState.handleKeys();
    stateManager.currentState.update();
    stateManager.currentState.draw();   
    
    if ( stateManager.transitioning )
    {
        //println("A");
        tint( 255, stateManager.transitionAlpha );
        stateManager.nextState.renderAlpha = stateManager.transitionAlpha;
        stateManager.nextState.draw();
        //noTint();

        stateManager.transitionAlpha += 10;

        if ( stateManager.transitionAlpha > 255 )
        {
            stateManager.transitionAlpha = 255;
            stateManager.transitioning = false;
            stateManager.transitionAlpha = 0;
            stateManager.currentState = stateManager.nextState;
            stateManager.nextState = null;
            println( "Transition Ready" );
        }
        noTint();
    }
    
}
