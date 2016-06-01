import ddf.minim.*;

class DungeonState extends State
{
    final static int ATTACK_ROCK = 0;
    final static int ATTACK_PAPER = 1;
    final static int ATTACK_SCISSORS = 2;
    
    final static int VICTOR_PLAYER = 0;
    final static int VICTOR_ENEMY = 1;
    final static int VICTOR_NONE = 3;
    
    Raycaster caster;
    Enemy enemy;
    
    boolean fightMode = false;
    boolean canAttack = true;
    Player player;
    int playerAttack = -1;
    
    PImage rockImage;
    PImage paperImage;
    PImage scissorsImage;
    
    PImage enemyHit;
    PImage playerHit;
    
    PImage combatBackground;
    
    int enemyHitAlpha = 0;
    int playerHitAlpha = 0;
    
    PGraphics pg;
    
    AudioPlayer step;
    AudioPlayer defeat;
    
    AudioPlayer hitYes;
    AudioPlayer hitNo;
    AudioPlayer hitNoOne;

    void init()
    {
        caster = new Raycaster();
        caster.renderAlpha = renderAlpha;
        caster.init();
        
        player = new Player();
        
        rockImage = loadImage( "rock.png" );
        paperImage = loadImage( "paper.png" );
        scissorsImage = loadImage( "scissors.png" );
        
        enemyHit = loadImage( "enemy_hit.png" );
        playerHit = loadImage( "player_hit.png" );
        
        combatBackground = loadImage( "combat_background.png" );
        
        step = minim.loadFile( "step.wav" );
        defeat = minim.loadFile( "explo.wav" );
        
        hitYes = minim.loadFile( "hit-yes.wav" );
        hitNo = minim.loadFile( "hit-no.wav" );
        hitNoOne = minim.loadFile( "hit-noone.wav" );
        
        pg = createGraphics( 800, 600 );
    }

    void handleKeys()
    {
        if ( keyPressed )
        {
            if ( fightMode ) return;

            if ( key == 'W' || key == 'w' )
            {
                step.play();
                caster.moveForward();
                int randomNumber = (int)random( 50 );
                
                if ( randomNumber == 25 )
                    startFight();
            }

            if ( key == 'A' || key == 'a' )
            {
                caster.rotateLeft();
            }

            if ( key == 'S' || key == 's' )
            {
                step.play();
                caster.moveBackwards();
            }

            if ( key == 'D' || key == 'd' )
            {
                caster.rotateRight();
            }

            if ( key == CODED )
            {
                if ( keyCode == UP )
                {
                    step.play();
                    caster.moveForward();
                    int randomNumber = (int)random( 50 );
                    
                    if ( randomNumber == 25 )
                        startFight();
                }

                if ( keyCode == DOWN )
                {
                    step.play();
                    caster.moveBackwards();
                }

                if ( keyCode == LEFT )
                    caster.rotateLeft();

                if ( keyCode == RIGHT )
                    caster.rotateRight();
            }
        }
    }
    
    void handleMouse()
    {
        int victor = -1;
        
        if ( !canAttack ) return;
        if ( !fightMode ) return;

        if ( fightMode )
        {
            // calculate collisions against "buttons"
            if ( mouseX > 250 && mouseX < 250 + 77 && mouseY > 400 && mouseY < 400 + 77 )
            {
                playerAttack = ATTACK_ROCK;
                canAttack = false;
                victor = evalAttack();
            }
            
            if ( mouseX > 350 && mouseX < 350 + 77 && mouseY > 400 && mouseY < 400 + 77 )
            {
                playerAttack = ATTACK_PAPER;
                canAttack = false;
                victor = evalAttack();
            }
            
            if ( mouseX > 450 && mouseX < 450 + 77 && mouseY > 400 && mouseY < 400 + 77 )
            {
                playerAttack = ATTACK_SCISSORS;
                canAttack = false;
                victor = evalAttack();
            }
        }
        
        switch ( victor )
        {
            case VICTOR_PLAYER:
                enemy.hp -= (int) abs( player.str - enemy.def * 0.5 );
                enemyHitAlpha = 255;
                hitYes.play();
                break;
                
            case VICTOR_ENEMY:
                player.hp -= (int) abs( enemy.str - player.def * 0.5 );
                playerHitAlpha = 255;
                hitNo.play();
                break;
                
            case VICTOR_NONE:
                hitNoOne.play();
                break;
        }
        
        if ( player.hp < 0 )
        {
            Babel.stateManager.switchState( StateManager.STATE_ENDING, false );
        }
        
        if ( enemy.hp < 0 )
        {
            defeat.play();
            fightMode = false;
            player.addXP( 10 * caster.currentFloor );
        }
    }

    void update()
    {
        if ( caster.currentFloor == 8 )
            Babel.stateManager.switchState( StateManager.STATE_ENDING, false );

        if ( fightMode )
        {
            if ( enemyHitAlpha > 0 )
            {
                enemyHitAlpha -= 5;
            }
            else
            {
                enemyHitAlpha = 0;
            }
            
            if ( playerHitAlpha > 0 )
            {
                playerHitAlpha -= 5;
            }
            else
            {
                playerHitAlpha = 0;
            }
            
            if ( ( enemyHitAlpha == 0 ) && ( playerHitAlpha == 0 ) )
            {
                canAttack = true;
            }
        }
    }

    void startFight()
    {
        fightMode = true;
        canAttack = true;
        enemyHitAlpha = 0;
        playerHitAlpha = 0;

        // generate enemies and stuff
        int enemyType = (int)random( 4 );
        enemy = new Enemy( enemyType, caster.currentFloor );
    }
    
    void drawHUD()
    {
        stroke( 0, 0, 0 );
        
        textFont( fontHUD, 12 );
        
        text( "HP: " + player.hp, 10, 540 );
        text( "LVL: " + player.level, 10, 555 );
        text( "STR: " + player.str, 10, 570 );
        text( "DEF: " + player.def, 10, 585 );
        
        text( "BF" + ( caster.currentFloor + 1 ), 760, 585 );
    }

    void draw()
    {
        //background( 125, 125, 125 );
        background( 145, 119, 137, renderAlpha );
        fill( 249, 218, 166, renderAlpha );
        rect( -1, -1, 801, 301 );
        caster.renderAlpha = renderAlpha;
        caster.draw();

        if ( fightMode )
        {
            //stroke( 0, 0, 0 );
            //fill( 255, 255, 255 );
            //rect( 30, 40, 740, 500 );
            image( combatBackground, 400 - ( combatBackground.width * 0.5 ), 300 - ( combatBackground.height * 0.5 ) );
            
            image( enemy.image, 370 - ( enemy.image.width / 2 ), 200 );
            tint(255, enemyHitAlpha);
            image( enemyHit, 370 - ( enemyHit.width / 2 ), 200 );
            noTint();
            
            pg.beginDraw();
            pg.background( 255, 255, 255, 0 );
            pg.image( rockImage, 250, 400 );
            pg.image( paperImage, 350, 400 );
            pg.image( scissorsImage, 450, 400 );
            
            if ( !canAttack )
                pg.filter( GRAY );
            
            pg.endDraw();   
     
            image( pg, 0, 0 );
            
            tint( 255, playerHitAlpha );
            image( playerHit, 40, 50 );
            noTint();
        }

        drawHUD();
    }
    
    int evalAttack()
    {
        int enemyAttack = (int) random( 4 );
        
        if ( enemyAttack == ATTACK_ROCK )
        {
            if ( playerAttack == ATTACK_PAPER )            
                return VICTOR_PLAYER;
                
            if ( playerAttack == ATTACK_SCISSORS )            
                return VICTOR_ENEMY;
        }
        
        if ( enemyAttack == ATTACK_PAPER )
        {
            if ( playerAttack == ATTACK_ROCK )            
                return VICTOR_ENEMY;
                
            if ( playerAttack == ATTACK_SCISSORS )            
                return VICTOR_PLAYER;
        }
        
        if ( enemyAttack == ATTACK_SCISSORS )
        {
            if ( playerAttack == ATTACK_ROCK )            
                return VICTOR_PLAYER;
                
            if ( playerAttack == ATTACK_PAPER )            
                return VICTOR_ENEMY;
        }
        
        //canAttack = true;
        return VICTOR_NONE;
    }
}

