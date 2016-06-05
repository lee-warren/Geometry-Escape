//
//  GameOverScreen.h
//  Red Ball
//
//  Created by Lee Warren on 28/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScreen : SKScene <SKPhysicsContactDelegate> {
    
    
    SKLabelNode *scoreLabel;//the score shown on the screen
    int currentScore;
    SKLabelNode *highScoreLabel;//the highscore shown on the screen
    int highScore;
    SKLabelNode *gemAmountLabel;//the coin total shown on screen
    int gemAmount;
    
    SKSpriteNode *player;
    SKSpriteNode *playerOutfit;
    NSString *playerOutiftName;
    
    //buttons on the screen
    SKSpriteNode *playAgainButton;
    SKSpriteNode *storeButton;
    SKSpriteNode *leaderboardsButton;
    SKSpriteNode *optionsButton;
    
    //delete later
    int randomCharacter;
    
    //saving highscores and stuff
    NSUserDefaults *defaults;

}

@end
