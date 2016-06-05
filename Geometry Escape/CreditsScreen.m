//
//  CreditsScreen.m
//  Geometry Escape
//
//  Created by Lee Warren on 12/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import "CreditsScreen.h"
#import "OptionsScreen.h"
#import "GameOverScreen.h"


@interface CreditsScreen ()
@property BOOL contentCreated;
@end

@implementation CreditsScreen


- (void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated)
    {
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    self.backgroundColor = [SKColor blackColor];
    
    
    returnToMenu = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    returnToMenu.text = [NSString stringWithFormat:@"<Return"];
    returnToMenu.fontSize = 40;
    returnToMenu.fontColor = [SKColor whiteColor];
    returnToMenu.position = CGPointMake(returnToMenu.frame.size.width/2 + self.frame.size.width/100*2, self.frame.size.height - self.frame.size.width/20 - self.frame.size.width/100*2 - returnToMenu.frame.size.height/2);
    returnToMenu.zPosition = 1.0;
    [self addChild:returnToMenu];
    
    [self addPageItems];
    
    
}


- (void) addPageItems {
    
    [self addChild: [self myMathsAppButton]];
    [self addChild:[self dontTouchTheGreenBallsButton]];
    //[self addChild:[self facebookLikeButton]];
    [self addChild:[self musicCreatorComment]];

}


- (SKSpriteNode *)myMathsAppButton {
    
    myMathsAppButton = [SKSpriteNode spriteNodeWithImageNamed:@"MainCreditButtons"];
    
    myMathsAppButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*32);
    myMathsAppButton.position = CGPointMake(self.frame.size.width/100 + myMathsAppButton.size.width/2, myMathsAppButton.size.height);
    

    SKSpriteNode *myMathsAppButtonPicture = [SKSpriteNode spriteNodeWithImageNamed:@"MyMaths"];
    myMathsAppButtonPicture.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*32);
    myMathsAppButtonPicture.position = CGPointMake(0,0);
    
    [myMathsAppButton addChild:myMathsAppButtonPicture];
    
    return myMathsAppButton;
}

- (SKSpriteNode *)dontTouchTheGreenBallsButton{
    
    dontTouchTheGreenBallsButton = [SKSpriteNode spriteNodeWithImageNamed:@"MainCreditButtons"];
    
    dontTouchTheGreenBallsButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*32);
    dontTouchTheGreenBallsButton.position = CGPointMake(self.frame.size.width/100 + dontTouchTheGreenBallsButton.size.width/2, myMathsAppButton.position.y +dontTouchTheGreenBallsButton.size.height + self.frame.size.width/100*2);
    
    SKSpriteNode *dontTouchTheGreenBallsButtonPicture = [SKSpriteNode spriteNodeWithImageNamed:@"DontTouchTheGreenBalls"];
    dontTouchTheGreenBallsButtonPicture.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*32);
    dontTouchTheGreenBallsButtonPicture.position = CGPointMake(0,0);
    
    [dontTouchTheGreenBallsButton addChild:dontTouchTheGreenBallsButtonPicture];
    
    return dontTouchTheGreenBallsButton;
}

/*
- (SKSpriteNode *)facebookLikeButton{
    
    facebookLikeButton = [SKSpriteNode spriteNodeWithImageNamed:@"MainCreditButtons"];
    
    facebookLikeButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*32);
    facebookLikeButton.position = CGPointMake(self.frame.size.width/100 + facebookLikeButton.size.width/2, dontTouchTheGreenBallsButton.position.y +facebookLikeButton.size.height + self.frame.size.width/100*2);
    
    
    SKLabelNode *theWordsCredits = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsCredits.text = @"Credits";
    theWordsCredits.fontSize = 30;
    theWordsCredits.position = CGPointMake(0,  - theWordsCredits.frame.size.height/2);
    
    [facebookLikeButton addChild:theWordsCredits];
    
    
    return facebookLikeButton;
}
*/

- (SKLabelNode *)musicCreatorComment{

    musicCreatorComment = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    musicCreatorComment.text = @"Music By Jesse Willingham";
    musicCreatorComment.fontSize = 20;
    musicCreatorComment.position = CGPointMake(self.frame.size.width/2, dontTouchTheGreenBallsButton.position.y + self.frame.size.height/4);
    //musicCreatorComment.position = CGPointMake(self.frame.size.width/2, facebookLikeButton.position.y + self.frame.size.height/6);
    return musicCreatorComment;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ((location.x > returnToMenu.position.x - returnToMenu.frame.size.width/2 -self.frame.size.width/100*3) && (location.x < returnToMenu.position.x +returnToMenu.frame.size.width/2 + self.frame.size.width/100*3) && ( location.y > returnToMenu.position.y -returnToMenu.frame.size.height/2 -self.frame.size.width/100*3) && (location.y < returnToMenu.position.y + returnToMenu.frame.size.height/2 +self.frame.size.width/100*3)) { //clicked on return to menu button
            
            //really is not needed
            [defaults synchronize];
            
            SKScene *optionsScreen  = [[OptionsScreen alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:optionsScreen transition:appear];
            
        }else if ((location.x > myMathsAppButton.position.x - myMathsAppButton.size.width/2 -self.frame.size.width/100) && (location.x < myMathsAppButton.position.x +myMathsAppButton.size.width/2 + self.frame.size.width/100) && ( location.y > myMathsAppButton.position.y -myMathsAppButton.size.height/2 -self.frame.size.width/100) && (location.y < myMathsAppButton.position.y + myMathsAppButton.size.height/2 +self.frame.size.width/100)) { //clicked on My Maths
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/au/app/my-maths/id897368293?mt=8"]];
            
        
        }else if ((location.x > dontTouchTheGreenBallsButton.position.x - dontTouchTheGreenBallsButton.size.width/2 -self.frame.size.width/100) && (location.x < dontTouchTheGreenBallsButton.position.x +dontTouchTheGreenBallsButton.size.width/2 + self.frame.size.width/100) && ( location.y > dontTouchTheGreenBallsButton.position.y -dontTouchTheGreenBallsButton.size.height/2 -self.frame.size.width/100) && (location.y < dontTouchTheGreenBallsButton.position.y + dontTouchTheGreenBallsButton.size.height/2 +self.frame.size.width/100)) { //clicked on Dont Touch The Green Balls
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/au/app/dont-touch-the-green-balls/id905219671?mt=8"]];
            
        }
        
        
    }
    
}


@end
