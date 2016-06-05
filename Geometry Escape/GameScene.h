//
//  GameScene.h
//  AvoidTheSquares - iOS
//

//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate> {
    
    SKSpriteNode *player;
    NSString *playerOutiftName;
    SKSpriteNode *playerOutfit;

    
    double scoreDoubleValue;
    int score;
    SKLabelNode *scoreLabel;//the score shown on the screen
        
    //the hand on the screen before the game begins
    SKSpriteNode *hand;
    
    //the four enemies
    SKSpriteNode *block1;
    SKSpriteNode *block2;
    SKSpriteNode *block3;
    SKSpriteNode *block4;
    
    //the coins that appear
    SKSpriteNode *gem;
    //the random coordinates the coin will go in
    int gemXValue;
    int gemYValue;
    //the coin value
    int gemCount;
    //coin total
    int gemTotal;
    
    //the Booleans that control the four blocks movements
    Boolean block1Left;
    Boolean block1Up;
    Boolean block2Left;
    Boolean block2Up;
    Boolean block3Left;
    Boolean block3Up;
    Boolean block4Left;
    Boolean block4Up;

    
    //speed of the enemies
    double speed;
    
    //where the player is on the screen
    CGPoint locationOfPlayer;
    
    
    CGPoint locationOfPlayerNow;
    CGPoint locationOfFinger;
    CGPoint locationOfFingerNow;
    BOOL moveThePlayerX;
    BOOL moveThePlayerY;
    
    //states whether the game has began or not
    Boolean gameOn;
    
    //states whether or not to show the tutorial
    BOOL dontShowTutorial;
    
    //tutorial stuff
    NSURL *fileURL;
    AVPlayer *_player;
    SKVideoNode *tutorial;
    
    SKSpriteNode *playTutorialButton;
    
    SKNode *TutorialHelpText;

    SKSpriteNode *dontPlayTutorialButton;
    SKLabelNode *theWordsDontPlayTutorial;
    
    SKSpriteNode *playButton;
    //
    
    //saving highscores and stuff
    NSUserDefaults *defaults;
    int highScore;
    
}

@end
