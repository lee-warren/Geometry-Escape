//
//  AboutScreen.m
//  AvoidTheSquares - iOS
//
//  Created by Lee Warren on 8/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import "OptionsScreen.h"
#import "GameOverScreen.h"
#import "CreditsScreen.h"
#import "GameScene.h"
#import "InAppManager.h"


@interface OptionsScreen ()
@property BOOL contentCreated;
@end

@implementation OptionsScreen


- (void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated)
    {
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    self.backgroundColor = [SKColor colorWithRed:109/255.0f green:131/255.0f blue:255/255.0f alpha:1.0f];
    
    
    returnToMenu = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    returnToMenu.text = [NSString stringWithFormat:@"<Return"];
    returnToMenu.fontSize = 40;
    returnToMenu.fontColor = [SKColor whiteColor];
    returnToMenu.position = CGPointMake(returnToMenu.frame.size.width/2 + self.frame.size.width/100*2, self.frame.size.height - self.frame.size.width/20 - self.frame.size.width/100*2 - returnToMenu.frame.size.height/2);
    returnToMenu.zPosition = 1.0;
    [self addChild:returnToMenu];
    
    [self addOptionItems];
    
    
}

- (void) addOptionItems {
    
    [self addChild: [self resetGameButton]];
    [self addChild:[self restorePurchasesButton]];
    [self addChild:[self creditsButton]];
    [self addChild:[self watchTutorialButton]];

}


- (SKSpriteNode *)resetGameButton {
    
    resetGameButton = [SKSpriteNode spriteNodeWithImageNamed:@"ResetGameButton"];
    
    resetGameButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    resetGameButton.position = CGPointMake(self.frame.size.width/100 + resetGameButton.size.width/2, resetGameButton.size.height*2);
    
    SKLabelNode *theWordsReset = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsReset.text = @"Reset Game";
    theWordsReset.fontSize = 30;
    theWordsReset.position = CGPointMake(0,  - theWordsReset.frame.size.height/2);
    
    [resetGameButton addChild:theWordsReset];
    
    return resetGameButton;
}

- (SKSpriteNode *)restorePurchasesButton{
    
    restorePurchasesButton = [SKSpriteNode spriteNodeWithImageNamed:@"ResetGameButton"];
    
    restorePurchasesButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    restorePurchasesButton.position = CGPointMake(self.frame.size.width/100 + restorePurchasesButton.size.width/2, resetGameButton.position.y +restorePurchasesButton.size.height + self.frame.size.width/100*2);
    
    SKLabelNode *theWordsRestorePurchases = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsRestorePurchases.text = @"Restore Purchases";
    theWordsRestorePurchases.fontSize = 30;
    theWordsRestorePurchases.position = CGPointMake(0,  - theWordsRestorePurchases.frame.size.height/2);
    
    [restorePurchasesButton addChild:theWordsRestorePurchases];
    
    return restorePurchasesButton;
}

- (SKSpriteNode *)creditsButton{
    
     creditsButton = [SKSpriteNode spriteNodeWithImageNamed:@"ResetGameButton"];
    
    creditsButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    creditsButton.position = CGPointMake(self.frame.size.width/100 + creditsButton.size.width/2, restorePurchasesButton.position.y +creditsButton.size.height + self.frame.size.width/100*2);
    
    SKLabelNode *theWordsCredits = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsCredits.text = @"Credits";
    theWordsCredits.fontSize = 30;
    theWordsCredits.position = CGPointMake(0,  - theWordsCredits.frame.size.height/2);
    
    [creditsButton addChild:theWordsCredits];
    
    return creditsButton;
}

- (SKSpriteNode *)watchTutorialButton{
    
    watchTutorialButton = [SKSpriteNode spriteNodeWithImageNamed:@"ResetGameButton"];
    
    watchTutorialButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    watchTutorialButton.position = CGPointMake(self.frame.size.width/100 + watchTutorialButton.size.width/2, creditsButton.position.y +watchTutorialButton.size.height + self.frame.size.width/100*2);
    
    SKLabelNode *theWordsWatchTutorial = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsWatchTutorial.text = @"View Tutorial";
    theWordsWatchTutorial.fontSize = 30;
    theWordsWatchTutorial.position = CGPointMake(0,  - theWordsWatchTutorial.frame.size.height/2);
    
    [watchTutorialButton addChild:theWordsWatchTutorial];
    
    return watchTutorialButton;
}

- (void) addLoadingScreen {
    
    pause = true;
    
    greyFadedBackground = [SKSpriteNode spriteNodeWithColor: [SKColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f] size:CGSizeMake(self.size.width, self.size.height)];
    greyFadedBackground.position = CGPointMake(self.size.width/2, self.size.height/2);
    greyFadedBackground.zPosition = 3;
    
    [self addChild:greyFadedBackground];
    
    player = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
    
    player.position = CGPointMake(0, 0);
    player.size = CGSizeMake(self.frame.size.width/11 , self.frame.size.width/11);
    //player.scale = 0.1;
    player.name = @"player";
    player.zPosition = 3;
    
    SKAction *action = [SKAction rotateByAngle:-M_PI/2 duration:1];
    
    [player runAction:[SKAction repeatActionForever:action]];
    [greyFadedBackground addChild:player];
    
    playerOutiftName = [defaults stringForKey:@"playerOutfit"];

    //playerOutfits Here
    
    if ([playerOutiftName  isEqual: @"SmilingFace"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"SmilingFace.png"];
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Batman"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Batman.png"];
        playerOutfit.position = CGPointMake(0, 7);
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Biker"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Biker.png"];
        playerOutfit.position = CGPointMake(-1, 0);
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Cyclops"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Cyclops.png"];
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Vampire"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Vampire.png"];
        playerOutfit.size = player.size;
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Pirate"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Pirate.png"];
        playerOutfit.position = CGPointMake(0, 1);
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Ninja"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Ninja.png"];
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"PoliceMan"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"PoliceMan1.png"];
        playerOutfit.position = CGPointMake(1, 2);
        
        [player addChild:playerOutfit];
        
        NSMutableArray *policeManTextures = [NSMutableArray arrayWithCapacity:15];
        
        for (int i = 1; i < 16; i++)
        {
            NSString *policeManTextureName = [NSString stringWithFormat:@"PoliceMan%d.png", i];
            SKTexture *policeManTexture =
            [SKTexture textureWithImageNamed:policeManTextureName];
            [policeManTextures addObject:policeManTexture];
        }
        
        SKAction* policeManSpriteAnimation = [SKAction animateWithTextures:policeManTextures timePerFrame:0.1];
        
        SKAction *policeManRepeat = [SKAction repeatActionForever:policeManSpriteAnimation];
        [playerOutfit runAction:policeManRepeat];
        
    } else if ([playerOutiftName  isEqual: @"Ghost"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Ghost.png"];
        [player addChild:playerOutfit];
        
    }  else if ([playerOutiftName  isEqual: @"TopHat"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"TopHat.png"];
        playerOutfit.position = CGPointMake(0,5);
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Astronaut"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Astronaut.png"];
        playerOutfit.position = CGPointMake(0,1);
        [player addChild:playerOutfit];
        
    } else if ([playerOutiftName  isEqual: @"Glasses"]) {
        
        playerOutfit = [SKSpriteNode spriteNodeWithImageNamed:@"Glasses.png"];
        playerOutfit.size = player.size;
        [player addChild:playerOutfit];
        
    }
    
    //
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ((location.x > returnToMenu.position.x - returnToMenu.frame.size.width/2 -self.frame.size.width/100*3) && (location.x < returnToMenu.position.x +returnToMenu.frame.size.width/2 + self.frame.size.width/100*3) && ( location.y > returnToMenu.position.y -returnToMenu.frame.size.height/2 -self.frame.size.width/100*3) && (location.y < returnToMenu.position.y + returnToMenu.frame.size.height/2 +self.frame.size.width/100*3)) { //clicked on return to menu button
            
            //might not be needed
            //[defaults setObject:playerOutiftName forKey:@"playerOutfit"];
            [defaults synchronize];
            
            SKScene *gameOverScreen  = [[GameOverScreen alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:gameOverScreen transition:appear];
        
        } else if ((location.x > resetGameButton.position.x - resetGameButton.size.width/2 -self.frame.size.width/100) && (location.x < resetGameButton.position.x +resetGameButton.size.width/2 + self.frame.size.width/100) && ( location.y > resetGameButton.position.y -resetGameButton.size.height/2 -self.frame.size.width/100) && (location.y < resetGameButton.position.y + resetGameButton.size.height/2 +self.frame.size.width/100)) { //clicked on reset game
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to reset game?"
                                                            message:@"All progress will be lost. This includes characters and gems."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Ok", nil];
            [alert show];
            
        
        } else if ((location.x > restorePurchasesButton.position.x - restorePurchasesButton.size.width/2 -self.frame.size.width/100) && (location.x < restorePurchasesButton.position.x +restorePurchasesButton.size.width/2 + self.frame.size.width/100) && ( location.y > restorePurchasesButton.position.y -restorePurchasesButton.size.height/2 -self.frame.size.width/100) && (location.y < restorePurchasesButton.position.y + restorePurchasesButton.size.height/2 +self.frame.size.width/100)) { //clicked on restore purchases
            
            
            [[InAppManager sharedManager]restoreCompletedTransactions];
            restorePurchasesButton.texture = [SKTexture textureWithImageNamed:@"SelectedLongStoreItemButtons.png"];
            [self addLoadingScreen];
            
            [self runAction:[SKAction waitForDuration:7] completion:^{
                
                restorePurchasesButton.texture = [SKTexture textureWithImageNamed:@"ResetGameButton"];

                //takes away the loading screen
                [greyFadedBackground removeFromParent];
                pause = false;
                
            }];

            
        } else if ((location.x > creditsButton.position.x - creditsButton.size.width/2 -self.frame.size.width/100) && (location.x < creditsButton.position.x +creditsButton.size.width/2 + self.frame.size.width/100) && ( location.y > creditsButton.position.y -creditsButton.size.height/2 -self.frame.size.width/100) && (location.y < creditsButton.position.y + creditsButton.size.height/2 +self.frame.size.width/100)) { //clicked on credits
            
            
            [self removeAllChildren];
            
            SKScene *creditsScreen  = [[CreditsScreen alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:creditsScreen transition:appear];
            
            
        } else if ((location.x > watchTutorialButton.position.x - watchTutorialButton.frame.size.width/2 -self.frame.size.width/100*3) && (location.x < watchTutorialButton.position.x +watchTutorialButton.frame.size.width/2 + self.frame.size.width/100*3) && ( location.y > watchTutorialButton.position.y -watchTutorialButton.frame.size.height/2 -self.frame.size.width/100*3) && (location.y < watchTutorialButton.position.y + watchTutorialButton.frame.size.height/2 +self.frame.size.width/100*3)) { //clicked on watchTutorialButton
            
            [self removeAllChildren];

            [defaults setBool:false forKey:@"dontShowTutorial"];
            [defaults synchronize];
            
            SKScene *gameScene  = [[GameScene alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:gameScene transition:appear];
            
        }
            
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        // do something here...
        
        //to be changed
        [defaults setBool:false forKey:@"boughtSmilingFace"];
        [defaults setBool:false forKey:@"boughtBatman"];
        [defaults setBool:false forKey:@"boughtBiker"];
        [defaults setBool:false forKey:@"boughtCyclops"];
        [defaults setBool:false forKey:@"boughtGlasses"];
        [defaults setBool:false forKey:@"boughtVampire"];
        [defaults setBool:false forKey:@"boughtPirate"];
        [defaults setBool:false forKey:@"boughtNinja"];
        [defaults setBool:false forKey:@"boughtPoliceMan"];
        [defaults setBool:false forKey:@"boughtTopHat"];
        [defaults setBool:false forKey:@"boughtAstronaut"];
        [defaults setInteger:0 forKey:@"gemAmount"];    //// change this to 0 when releasing game
        [defaults setObject:@"" forKey:@"playerOutfit"];
        [defaults setInteger:0 forKey:@"currentScore"];
        [defaults setInteger:0 forKey:@"highScore"];
        [defaults setBool:false forKey:@"dontShowTutorial"];
        [defaults synchronize];
    }
}


@end
