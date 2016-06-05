//
//  StoreScreen.h
//  AvoidTheSquares - iOS
//
//  Created by Lee Warren on 8/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface StoreScreen : SKScene {
    
    //saving which stuff is bought and stuff
    NSUserDefaults *defaults;
    
    SKSpriteNode *gem;
    SKLabelNode *gemAmountLabel;
    int gemAmount;
    
    SKLabelNode *returnToMenu;
    
    NSString *playerOutiftName;
    
    SKAction *flashRed;
    
    BOOL boughtSmilingFace;
    BOOL boughtBiker;
    BOOL boughtCyclops;
    BOOL boughtVampire;
    BOOL boughtNinja;
    BOOL boughtTopHat;
    BOOL boughtAstronaut;
    BOOL boughtPoliceMan;
    BOOL boughtBatman;
    BOOL boughtPirate;
    BOOL boughtGlasses;

    
    
    //purchases
    
    SKSpriteNode *itemBlankPlayer;
    
    SKSpriteNode *itemSmilingFace;
    SKSpriteNode *smilingFace;
    SKLabelNode *priceForSmilingFace;
    int smilingFacePrice;
    
    SKSpriteNode *itemBiker;
    SKSpriteNode *biker;
    SKLabelNode *priceForBiker;
    int bikerPrice;
    
    SKSpriteNode *itemCyclops;
    SKSpriteNode *cyclops;
    SKLabelNode *priceForCyclops;
    int cyclopsPrice;
    
    SKSpriteNode *itemVampire;
    SKSpriteNode *vampire;
    SKLabelNode *priceForVampire;
    int vampirePrice;

    SKSpriteNode *itemNinja;
    SKSpriteNode *ninja;
    SKLabelNode *priceForNinja;
    int ninjaPrice;
    
    SKSpriteNode *itemTopHat;
    SKSpriteNode *topHat;
    SKLabelNode *priceForTopHat;
    int topHatPrice;

    SKSpriteNode *itemAstronaut;
    SKSpriteNode *astronaut;
    SKLabelNode *priceForAstronaut;
    int astronautPrice;
    
    SKSpriteNode *itemPoliceMan;
    SKSpriteNode *policeMan;
    SKLabelNode *priceForPoliceMan;
    int policeManPrice;
    
    SKSpriteNode *itemBatman;
    SKSpriteNode *batman;
    SKLabelNode *priceForBatman;
    int batmanPrice;
    
    SKSpriteNode *itemPirate;
    SKSpriteNode *pirate;
    SKLabelNode *priceForPirate;
    int piratePrice;
    
    SKSpriteNode *itemGlasses;
    SKSpriteNode *glasses;
    SKLabelNode *priceForGlasses;
    int glassesPrice;
    
    //

    
    //inAppPurchases
    SKSpriteNode *item2xGems;
    SKLabelNode *item2xGemsDescription;
    
    SKSpriteNode *itemMoreGems;
    SKLabelNode *itemMoreGemsDescription;

    //loading screen
    SKSpriteNode *greyFadedBackground;
    SKSpriteNode *player;
    SKSpriteNode *playerOutfit;
    bool pause;
}

@end
