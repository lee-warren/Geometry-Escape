//
//  CreditsScreen.h
//  Geometry Escape
//
//  Created by Lee Warren on 12/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CreditsScreen : SKScene{
    
    //saving which stuff is bought and stuff
    //(not really needed on credits screen but whatever)
    NSUserDefaults *defaults;
    
    SKLabelNode *returnToMenu;
    
    SKSpriteNode *facebookLikeButton;
    SKSpriteNode *myMathsAppButton;
    SKSpriteNode *dontTouchTheGreenBallsButton;
    SKLabelNode *musicCreatorComment;
    
}


@end
