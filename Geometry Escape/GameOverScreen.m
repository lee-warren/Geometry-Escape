//
//  GameOverScreen.m
//  Red Ball
//
//  Created by Lee Warren on 28/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "GameOverScreen.h"
#import "GameScene.h"
#import "StoreScreen.h"
#import "OptionsScreen.h"
#import <GameKit/GameKit.h>

@interface GameOverScreen () <GKGameCenterControllerDelegate>
@property BOOL contentCreated;
@end

@implementation GameOverScreen


- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
        //Sends message to viewcontroller to show ad.
        
        self.physicsWorld.contactDelegate = self;
        
        defaults = [NSUserDefaults standardUserDefaults];

        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    
    self.backgroundColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1.0f];
   
    currentScore = (int)[defaults integerForKey:@"currentScore"];
    highScore = (int)[defaults integerForKey:@"highScore"];
    gemAmount = (int)[defaults integerForKey:@"gemAmount"];
    
    playerOutiftName = [defaults stringForKey:@"playerOutfit"];

    if ([defaults boolForKey:@"PlayDyingSound"] == true) {
        [self runAction:[SKAction playSoundFileNamed:@"DyingSound.mp3" waitForCompletion:YES]completion:^ {
        [defaults setBool:false forKey:@"PlayDyingSound"];
        [defaults synchronize];

    }];
    }

    [self addChild: [self scoreStuffNode]];
    
    [self addChild: [self playAgainButton]];
    
    [self addChild: [self storeButton]];
    
    [self addChild: [self leaderboardsButton]];
    
    [self addChild: [self optionsButton]];
    
    
    
}

- (SKSpriteNode *)scoreStuffNode
{
    SKSpriteNode *scoreStuffHolder = [[SKSpriteNode alloc] init];
    scoreStuffHolder.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    scoreStuffHolder.zPosition = 1;
    
    highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    highScoreLabel.text = [NSString stringWithFormat:@"Highscore: %d",highScore];
    highScoreLabel.fontSize = 40;
    highScoreLabel.fontColor = [SKColor colorWithRed:255/255.0f green:251/255.0f blue:102/255.0f alpha:1.0f];

    highScoreLabel.position = CGPointMake(self.size.width/2,self.size.height/1.76);
    highScoreLabel.zPosition = 1.0;
    [self addChild:highScoreLabel];
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    scoreLabel.text = [NSString stringWithFormat:@"%d",currentScore];
    scoreLabel.fontSize = 200;
    scoreLabel.fontColor = [SKColor colorWithRed:255/255.0f green:251/255.0f blue:102/255.0f alpha:1.0f];
    
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height-highScoreLabel.position.y/2);
    scoreLabel.zPosition = 1.0;
    [self addChild:scoreLabel];
    
    gemAmountLabel = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    gemAmountLabel.text = [NSString stringWithFormat:@"Gems: %d",gemAmount];
    gemAmountLabel.fontSize = 40;
    gemAmountLabel.fontColor = [SKColor colorWithRed:81/255.0f green:232/255.0f blue:159/255.0f alpha:1.0f];
    gemAmountLabel.position = CGPointMake(self.size.width/2, highScoreLabel.position.y - highScoreLabel.frame.size.height/2*3
                                          );
    gemAmountLabel.zPosition = 1.0;
    [self addChild:gemAmountLabel];
    
    return scoreStuffHolder;
}

- (SKSpriteNode *)playAgainButton {
    
    playAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayAgainButton"];
    
    playAgainButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    playAgainButton.position = CGPointMake(self.frame.size.width/100 + playAgainButton.size.width/2, self.frame.size.height/4);
    
    SKLabelNode *theWordsPlayAgain = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsPlayAgain.text = @"Play Again";
    theWordsPlayAgain.fontSize = 30;
    theWordsPlayAgain.position = CGPointMake(0,  - theWordsPlayAgain.frame.size.height/2);
    
    [playAgainButton addChild:theWordsPlayAgain];

    return playAgainButton;
}

- (SKSpriteNode *)storeButton {
    
    storeButton = [SKSpriteNode spriteNodeWithImageNamed:@"StoreButton"];
    
    storeButton.size = CGSizeMake(self.frame.size.width/100 *32, self.frame.size.width/100*16);
    storeButton.position = CGPointMake(self.frame.size.width/100 + storeButton.size.width/2, playAgainButton.position.y + playAgainButton.size.height + self.frame.size.width/100*2);
    
    SKLabelNode *theWordStore = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordStore.text = @"Shop";
    theWordStore.fontSize = 30;
    theWordStore.position = CGPointMake(0,  - theWordStore.frame.size.height/2);
    
    [storeButton addChild:theWordStore];
    
    return storeButton;
}


- (SKSpriteNode *)leaderboardsButton {
    
    leaderboardsButton = [SKSpriteNode spriteNodeWithImageNamed:@"SpareButton"];
    
    leaderboardsButton.size = CGSizeMake(self.frame.size.width/100 *32, self.frame.size.width/100*16);
    leaderboardsButton.position = CGPointMake(self.frame.size.width/2, playAgainButton.position.y + playAgainButton.size.height + self.frame.size.width/100*2);
    
    /*
    SKLabelNode *theWordScores = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordScores.text = @"Scores";
    theWordScores.fontSize = 30;
    theWordScores.position = CGPointMake(0,  - theWordScores.frame.size.height/2);
    
    [leaderboardsButton addChild:theWordScores];
     */
    
    SKSpriteNode *theLeaderboardsSymbol = [SKSpriteNode spriteNodeWithImageNamed:@"LeaderboardButtonStuff.png"];
    theLeaderboardsSymbol.size = CGSizeMake(self.frame.size.width/100*9.5, self.frame.size.width/100*10);

    theLeaderboardsSymbol.position = CGPointMake(0, 0);
    
    [leaderboardsButton addChild:theLeaderboardsSymbol];
     
    
    return leaderboardsButton;
}


- (SKSpriteNode *)optionsButton {
    
    optionsButton = [SKSpriteNode spriteNodeWithImageNamed:@"AboutButton"];
    
    optionsButton.size = CGSizeMake(self.frame.size.width/100 *32, self.frame.size.width/100*16);
    optionsButton.position = CGPointMake(self.frame.size.width - optionsButton.size.width/2 - self.frame.size.width/100, playAgainButton.position.y + playAgainButton.size.height + self.frame.size.width/100*2);
    
    SKLabelNode *theWordOptions = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordOptions.text = @"Options";
    theWordOptions.fontSize = 30;
    theWordOptions.position = CGPointMake(0,  - theWordOptions.frame.size.height/2);
    
    [optionsButton addChild:theWordOptions];
    
    return optionsButton;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    
        if ((location.x > playAgainButton.position.x - playAgainButton.size.width/2 -self.frame.size.width/100) && (location.x < playAgainButton.position.x +playAgainButton.size.width/2 + self.frame.size.width/100) && ( location.y > playAgainButton.position.y -playAgainButton.size.height/2 -self.frame.size.width/100) && (location.y < playAgainButton.position.y + playAgainButton.size.height/2 +self.frame.size.width/100)) { //clicked on play agin button
            
            //might not be needed
            [defaults setObject:playerOutiftName forKey:@"playerOutfit"];
            [defaults setBool:false forKey:@"PlayDyingSound"];
            [defaults synchronize];
            
            [self removeAllChildren];
            
            SKScene *gameScene  = [[GameScene alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:gameScene transition:appear];
            
            
        } else if ((location.x > storeButton.position.x - storeButton.size.width/2 -self.frame.size.width/100) && (location.x < storeButton.position.x +storeButton.size.width/2 + self.frame.size.width/100) && ( location.y > storeButton.position.y -storeButton.size.height/2 -self.frame.size.width/100) && (location.y < storeButton.position.y + storeButton.size.height/2 +self.frame.size.width/100)) { //clicked on store
            
            [self removeAllChildren];
            
            [defaults setBool:false forKey:@"PlayDyingSound"];
            [defaults synchronize];
            
            SKScene *storeScreen  = [[StoreScreen alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:storeScreen transition:appear];
            
            
            
        } else if ((location.x > leaderboardsButton.position.x - leaderboardsButton.size.width/2 -self.frame.size.width/100) && (location.x < leaderboardsButton.position.x +leaderboardsButton.size.width/2 + self.frame.size.width/100) && ( location.y > leaderboardsButton.position.y -leaderboardsButton.size.height/2 -self.frame.size.width/100) && (location.y < leaderboardsButton.position.y + leaderboardsButton.size.height/2 +self.frame.size.width/100)) { //clicked on leaderboards
            
            [defaults setBool:false forKey:@"PlayDyingSound"];
            [defaults synchronize];
            
            //gamecenter stuff
            UIViewController *vc = self.view.window.rootViewController;
            GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
            if (gameCenterController != nil)
            {
                gameCenterController.gameCenterDelegate = self;
                [vc presentViewController: gameCenterController animated: YES completion:nil];
            }
            
            
            
        } else if ((location.x > optionsButton.position.x - optionsButton.size.width/2 -self.frame.size.width/100) && (location.x < optionsButton.position.x +optionsButton.size.width/2 + self.frame.size.width/100) && ( location.y > optionsButton.position.y -optionsButton.size.height/2 -self.frame.size.width/100) && (location.y < optionsButton.position.y + optionsButton.size.height/2 +self.frame.size.width/100)) { //clicked on options
            
            [self removeAllChildren];
            
            [defaults setBool:false forKey:@"PlayDyingSound"];
            [defaults synchronize];
            
            SKScene *optionsScreen  = [[OptionsScreen alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:optionsScreen transition:appear];
            
            
        }
        
    }
    
}

//gamecenter stuff
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
