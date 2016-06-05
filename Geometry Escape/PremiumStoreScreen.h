//
//  PremiumStoreScreen.h
//  Geometry Escape
//
//  Created by Lee Warren on 12/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PremiumStoreScreen : SKScene {
    
    NSUserDefaults *defaults;
    
    SKSpriteNode *gem;
    SKLabelNode *gemAmountLabel;
    int gemAmount;
    
    SKLabelNode *returnToMenu;
    
    SKAction *flashGreen;
    
    //items
    
    SKSpriteNode *itemSmallGemPack;
    SKLabelNode *itemSmallGemPackDescription;
    
    SKSpriteNode *itemMediumGemPack;
    SKLabelNode *itemMediumGemPackDescription;
    
    SKSpriteNode *itemLargeGemPack;
    SKLabelNode *itemLargeGemPackDescription;
    
    SKSpriteNode *item2xGems;
    SKLabelNode *item2xGemsDescription;
 
    //loading screen
    NSString *playerOutiftName;
    SKSpriteNode *greyFadedBackground;
    SKSpriteNode *player;
    SKSpriteNode *playerOutfit;
    bool pause;
}

@end
