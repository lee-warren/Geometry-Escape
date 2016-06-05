//
//  AboutScreen.h
//  AvoidTheSquares - iOS
//
//  Created by Lee Warren on 8/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OptionsScreen : SKScene {
    
    //saving which stuff is bought and stuff
    NSUserDefaults *defaults;
    
    SKLabelNode *returnToMenu;

    SKSpriteNode *resetGameButton;
    SKSpriteNode *restorePurchasesButton;
    SKSpriteNode *creditsButton;
    SKSpriteNode *watchTutorialButton;

    //loading screen
    NSString *playerOutiftName;
    SKSpriteNode *greyFadedBackground;
    SKSpriteNode *player;
    SKSpriteNode *playerOutfit;
    bool pause;
}

@end
