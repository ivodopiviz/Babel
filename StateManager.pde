class StateManager
{
    final static int STATE_MENU = 0;
    final static int STATE_DUNGEON = 1;
    final static int STATE_ENDING = 2;
    
    State currentState = null;
    State nextState = null;
    boolean transitioning = false;

    int transitionAlpha = 0;

    void switchState( int newState, boolean useTransition )
    {
        switch( newState )
        {
            case STATE_MENU:
                nextState = new MenuState();
                break;
            
            case STATE_DUNGEON:
                nextState = new DungeonState();
                break;
            
            case STATE_ENDING:
                nextState = new EndingState();
                break;
        }
        
        nextState.init();
        transitioning = useTransition;
        if ( !useTransition )
        {
            currentState = nextState;
            return;
        }
    }
}
