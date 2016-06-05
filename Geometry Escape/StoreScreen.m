//
//  StoreScreen.m
//  AvoidTheSquares - iOS
//
//  Created by Lee Warren on 8/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import "StoreScreen.h"
#import "GameOverScreen.h"
#import "InAppManager.h"
#import "PremiumStoreScreen.h"

@interface StoreScreen ()
@property BOOL contentCreated;
@end

@implementation StoreScreen


- (void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated)
    {
                
        defaults = [NSUserDefaults standardUserDefaults];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    self.backgroundColor = [SKColor colorWithRed:81/255.0f green:232/255.0f blue:159/255.0f alpha:1.0f];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct1) name:@"feature1Purchased" object:nil];
    
    gemAmount = (int)[defaults integerForKey:@"gemAmount"];
    playerOutiftName = [defaults stringForKey:@"playerOutfit"];
    
    boughtSmilingFace = [defaults boolForKey:@"boughtSmilingFace"];
    boughtBiker = [defaults boolForKey:@"boughtBiker"];
    boughtCyclops = [defaults boolForKey:@"boughtCyclops"];
    boughtVampire = [defaults boolForKey:@"boughtVampire"];
    boughtNinja = [defaults boolForKey:@"boughtNinja"];
    boughtTopHat = [defaults boolForKey:@"boughtTopHat"];
    boughtAstronaut = [defaults boolForKey:@"boughtAstronaut"];
    boughtPoliceMan = [defaults boolForKey:@"boughtPoliceMan"];
    boughtBatman = [defaults boolForKey:@"boughtBatman"];
    boughtPirate = [defaults boolForKey:@"boughtPirate"];
    boughtGlasses = [defaults boolForKey:@"boughtGlasses"];
    
    //prices for all the different outifts
    smilingFacePrice = 10;
    glassesPrice = 25;
    vampirePrice = 50;
    cyclopsPrice = 50;
    astronautPrice = 50;
    bikerPrice = 100;
    ninjaPrice = 100;
    topHatPrice = 100;
    policeManPrice = 250;
    batmanPrice = 250;
    piratePrice = 250;
    //
    
    gem = [[SKSpriteNode alloc] initWithImageNamed:@"gem1.png"];
    gem.zPosition = 1;
    gem.size=CGSizeMake(self.frame.size.width/10 , self.frame.size.width/10);
    
    gem.position = CGPointMake(self.frame.size.width - gem.frame.size.width/2 - self.frame.size.width/100*2, self.frame.size.height - gem.frame.size.height/2 - self.frame.size.width/100*2);
    
    
    [self addChild:gem];
    
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:18];
    
    for (int i = 1; i < 19; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"gem%d.png", i];
        SKTexture *texture =
        [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    SKAction* spriteAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    SKAction *repeat = [SKAction repeatActionForever:spriteAnimation];
    [gem runAction:repeat];

    
    gemAmountLabel = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
    gemAmountLabel.fontSize = 40;
    gemAmountLabel.fontColor = [SKColor whiteColor];
    gemAmountLabel.position = CGPointMake(gem.position.x - gemAmountLabel.frame.size.width/2 - gem.frame.size.width/2 - self.frame.size.width/100*2, gem.position.y - gemAmountLabel.frame.size.height/2);
    gemAmountLabel.zPosition = 1.0;
    [self addChild:gemAmountLabel];

    returnToMenu = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    returnToMenu.text = [NSString stringWithFormat:@"<Return"];
    returnToMenu.fontSize = 40;
    returnToMenu.fontColor = [SKColor whiteColor];
    returnToMenu.position = CGPointMake( returnToMenu.frame.size.width/2 + self.frame.size.width/100*2, gem.position.y - returnToMenu.frame.size.height/2);

    returnToMenu.zPosition = 1.0;
    [self addChild:returnToMenu];

    
    
    [self addShopItems];
    
}

- (void) addShopItems {
    
    //premium purchase - buy more gems
    [self addChild: [self  itemMoreGems]];
    
    //premium purchase - 2xgems
    [self addChild: [self  item2xGems]];
    
    if ([[InAppManager sharedManager]isFeature1PurchasedAlready] == YES) {
        
        item2xGems.texture = [SKTexture textureWithImageNamed:@"LongBlueStoreItemButtons.png"];
    }
    
    //blank player
    [self addChild: [self itemBlankPlayer]];
    
    if ([playerOutiftName isEqualToString:@""]) {
        
        itemBlankPlayer.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        
    }
    
    //smiling face
    [self addChild: [self itemSmilingFace]];
    
    if ([playerOutiftName isEqualToString:@"SmilingFace"]) {
        
        itemSmilingFace.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        smilingFace.texture = [SKTexture textureWithImageNamed:@"SmilingFace"];
        [priceForSmilingFace removeFromParent];
        
        
    } else if (boughtSmilingFace == true){
        
        itemSmilingFace.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        smilingFace.texture = [SKTexture textureWithImageNamed:@"SmilingFace"];
        [priceForSmilingFace removeFromParent];
        
    }
    
    //glasses
    [self addChild: [self  itemGlasses]];
    
    if ([playerOutiftName isEqualToString:@"Glasses"]) {
        
        itemGlasses.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        glasses.texture = [SKTexture textureWithImageNamed:@"Glasses"];
        [priceForGlasses removeFromParent];
        
        
    } else if (boughtGlasses == true){
        
        itemGlasses.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        glasses.texture = [SKTexture textureWithImageNamed:@"Glasses"];
        [priceForGlasses removeFromParent];
        
    }
    
    //cyclops
    [self addChild: [self  itemCyclops]];
    
    if ([playerOutiftName isEqualToString:@"Cyclops"]) {
        
        itemCyclops.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        cyclops.texture = [SKTexture textureWithImageNamed:@"Cyclops"];
        [priceForCyclops removeFromParent];
        
        
    } else if (boughtCyclops == true){
        
        itemCyclops.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        cyclops.texture = [SKTexture textureWithImageNamed:@"Cyclops"];
        [priceForCyclops removeFromParent];
        
    }
    
    //astronaut
    [self addChild: [self  itemAstronaut]];
    
    if ([playerOutiftName isEqualToString:@"Astronaut"]) {
        
        itemAstronaut.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        astronaut.texture = [SKTexture textureWithImageNamed:@"Astronaut"];
        [priceForAstronaut removeFromParent];
        
        
    } else if (boughtAstronaut == true){
        
        itemAstronaut.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        astronaut.texture = [SKTexture textureWithImageNamed:@"Astronaut"];
        [priceForAstronaut removeFromParent];
        
    }
    
    //vampire
    [self addChild: [self  itemVampire]];
    
    if ([playerOutiftName isEqualToString:@"Vampire"]) {
        
        itemVampire.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        vampire.texture = [SKTexture textureWithImageNamed:@"Vampire"];
        [priceForVampire removeFromParent];
        
        
    } else if (boughtVampire == true){
        
        itemVampire.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        vampire.texture = [SKTexture textureWithImageNamed:@"Vampire"];
        [priceForVampire removeFromParent];
        
    }
    
    //ninja
    [self addChild: [self  itemNinja]];
    
    if ([playerOutiftName isEqualToString:@"Ninja"]) {
        
        itemNinja.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        ninja.texture = [SKTexture textureWithImageNamed:@"Ninja"];
        [priceForNinja removeFromParent];
        
        
    } else if (boughtNinja == true){
        
        itemNinja.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        ninja.texture = [SKTexture textureWithImageNamed:@"Ninja"];
        [priceForNinja removeFromParent];
        
    }
    
    //biker
    [self addChild: [self itemBiker]];
    
    if ([playerOutiftName isEqualToString:@"Biker"]) {
        
        itemBiker.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        biker.texture = [SKTexture textureWithImageNamed:@"Biker"];
        [priceForBiker removeFromParent];
        
        
    } else if (boughtBiker == true){
        
        itemBiker.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        biker.texture = [SKTexture textureWithImageNamed:@"Biker"];
        [priceForBiker removeFromParent];
        
    }
    
    //top hat
    [self addChild: [self itemTopHat]];
    
    if ([playerOutiftName isEqualToString:@"TopHat"]) {
        
        itemTopHat.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        topHat.texture = [SKTexture textureWithImageNamed:@"TopHat"];
        [priceForTopHat removeFromParent];
        
        
    } else if (boughtTopHat == true){
        
        itemTopHat.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        topHat.texture = [SKTexture textureWithImageNamed:@"TopHat"];
        [priceForTopHat removeFromParent];
        
    }
    
    //policeMan
    [self addChild: [self itemPoliceMan]];
    
    if ([playerOutiftName isEqualToString:@"PoliceMan"]) {
        
        itemPoliceMan.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        policeMan.texture = [SKTexture textureWithImageNamed:@"PoliceMan1"];
        [priceForPoliceMan removeFromParent];
        
        
    } else if (boughtPoliceMan == true){
        
        itemPoliceMan.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        policeMan.texture = [SKTexture textureWithImageNamed:@"PoliceMan1"];
        [priceForPoliceMan removeFromParent];
        
    }
    
    //batman
    [self addChild: [self itemBatman]];
    
    if ([playerOutiftName isEqualToString:@"Batman"]) {
        
        itemBatman.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        batman.texture = [SKTexture textureWithImageNamed:@"Batman"];
        [priceForBatman removeFromParent];
        
        
    } else if (boughtBatman == true){
        
        itemBatman.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        batman.texture = [SKTexture textureWithImageNamed:@"Batman"];
        [priceForBatman removeFromParent];
        
    }
    
    //pirate
    [self addChild: [self  itemPirate]];
    
    if ([playerOutiftName isEqualToString:@"Pirate"]) {
        
        itemPirate.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
        pirate.texture = [SKTexture textureWithImageNamed:@"Pirate"];
        [priceForPirate removeFromParent];
        
        
    } else if (boughtPirate == true){
        
        itemPirate.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        pirate.texture = [SKTexture textureWithImageNamed:@"Pirate"];
        [priceForPirate removeFromParent];
        
    }
    
    if (([UIScreen mainScreen].bounds.size.height == 480)) { //iphone 4s - do something different
        itemMoreGems.position = item2xGems.position;
        item2xGems.position = CGPointMake(self.scene.size.width*2, 0);
        [item2xGems removeFromParent];
    }
    
    
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

- (SKSpriteNode *)itemMoreGems {
    
    itemMoreGems = [SKSpriteNode spriteNodeWithImageNamed:@"LongStoreItemButtons"];
    
    itemMoreGems.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    if (([UIScreen mainScreen].bounds.size.height == 480)) { //iphone 4s - do something different
        itemMoreGems.position = CGPointMake(self.frame.size.width/100 + itemMoreGems.size.width/2, itemMoreGems.size.height*1);
    } else { //all other sized phones
        itemMoreGems.position = CGPointMake(self.frame.size.width/100 + itemMoreGems.size.width/2, itemMoreGems.size.height*2);
    }
    
    itemMoreGemsDescription = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    itemMoreGemsDescription.text = [NSString stringWithFormat:@"Buy More Gems"];
    itemMoreGemsDescription.fontSize = 30;
    itemMoreGemsDescription.position = CGPointMake(0,  - itemMoreGemsDescription.frame.size.height/2);
    
    [itemMoreGems addChild:itemMoreGemsDescription];
    
    return itemMoreGems;
}

- (SKSpriteNode *)item2xGems {
    
    item2xGems = [SKSpriteNode spriteNodeWithImageNamed:@"LongStoreItemButtons"];
    
    item2xGems.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    item2xGems.position = CGPointMake(self.frame.size.width/100 + item2xGems.size.width/2, itemMoreGems.position.y +item2xGems.size.height + self.frame.size.width/100*2);
    
    item2xGemsDescription = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    item2xGemsDescription.text = [NSString stringWithFormat:@"Gem Doubler $%.02f",(double)[defaults doubleForKey:@"priceOfProduct0"]];
    item2xGemsDescription.fontSize = 30;
    item2xGemsDescription.position = CGPointMake(0,  - item2xGemsDescription.frame.size.height/2);
    
    [item2xGems addChild:item2xGemsDescription];
    
    return item2xGems;
}

- (SKSpriteNode *)itemBlankPlayer {

    itemBlankPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"YellowStoreButtons"];
    
    itemBlankPlayer.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemBlankPlayer.position = CGPointMake(self.frame.size.width/100 + itemBlankPlayer.size.width/2, itemMoreGems.position.y +item2xGems.size.height*6 + self.frame.size.width/100*12);
    
    return itemBlankPlayer;
    
}

- (SKSpriteNode *)itemSmilingFace {
    
    itemSmilingFace = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemSmilingFace.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemSmilingFace.position = CGPointMake(self.frame.size.width/2, itemBlankPlayer.position.y);

    priceForSmilingFace = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForSmilingFace.text = [NSString stringWithFormat:@"%d", smilingFacePrice];
    priceForSmilingFace.fontSize = 30;
    priceForSmilingFace.position = CGPointMake(0,  - priceForSmilingFace.frame.size.height/2);
        
    [itemSmilingFace addChild:priceForSmilingFace];
    
    smilingFace = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemSmilingFace addChild:smilingFace];

    return itemSmilingFace;
}

- (SKSpriteNode *)itemGlasses {
    
    itemGlasses = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemGlasses.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemGlasses.position = CGPointMake(self.frame.size.width -itemGlasses.size.width/2 - self.frame.size.width/100 , itemBlankPlayer.position.y);
    
    priceForGlasses = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForGlasses.text = [NSString stringWithFormat:@"%d", glassesPrice];
    priceForGlasses.fontSize = 30;
    priceForGlasses.position = CGPointMake(0,  - priceForGlasses.frame.size.height/2);
    
    [itemGlasses addChild:priceForGlasses];
    
    glasses = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemGlasses addChild:glasses];
    
    return itemGlasses;
}

- (SKSpriteNode *)itemCyclops {
    
    itemCyclops = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemCyclops.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemCyclops.position = CGPointMake(itemBlankPlayer.position.x , itemBlankPlayer.position.y - itemCyclops.size.height - self.frame.size.width/100);
    
    priceForCyclops = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForCyclops.text = [NSString stringWithFormat:@"%d", cyclopsPrice];
    priceForCyclops.fontSize = 30;
    priceForCyclops.position = CGPointMake(0,  - priceForCyclops.frame.size.height/2);
    
    [itemCyclops addChild:priceForCyclops];
    
    cyclops = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemCyclops addChild:cyclops];

    
    return itemCyclops;
}

- (SKSpriteNode *)itemAstronaut {
    
    itemAstronaut = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemAstronaut.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemAstronaut.position = CGPointMake(itemSmilingFace.position.x, itemCyclops.position.y);
    
    priceForAstronaut = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForAstronaut.text = [NSString stringWithFormat:@"%d", astronautPrice];
    priceForAstronaut.fontSize = 30;
    priceForAstronaut.position = CGPointMake(0,  - priceForAstronaut.frame.size.height/2);
    
    [itemAstronaut addChild:priceForAstronaut];
    
    astronaut = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemAstronaut addChild:astronaut];
    
    return itemAstronaut;
}

- (SKSpriteNode *)itemVampire {
    
    itemVampire = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemVampire.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemVampire.position = CGPointMake(self.frame.size.width -itemVampire.size.width/2 - self.frame.size.width/100 , itemCyclops.position.y);
    
    priceForVampire = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForVampire.text = [NSString stringWithFormat:@"%d", vampirePrice];
    priceForVampire.fontSize = 30;
    priceForVampire.position = CGPointMake(0,  - priceForVampire.frame.size.height/2);
    
    [itemVampire addChild:priceForVampire];
    
    vampire = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemVampire addChild:vampire];
    
    return itemVampire;
}

- (SKSpriteNode *)itemNinja {
    
    itemNinja = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemNinja.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemNinja.position = CGPointMake(itemBlankPlayer.position.x, itemCyclops.position.y - itemNinja.size.height - self.frame.size.width/100);
    
    priceForNinja = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForNinja.text = [NSString stringWithFormat:@"%d", ninjaPrice];
    priceForNinja.fontSize = 30;
    priceForNinja.position = CGPointMake(0,  - priceForNinja.frame.size.height/2);
    
    [itemNinja addChild:priceForNinja];
    
    ninja = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemNinja addChild:ninja];
    
    return itemNinja;
}

- (SKSpriteNode *)itemBiker {
    
    itemBiker = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemBiker.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemBiker.position = CGPointMake(itemSmilingFace.position.x,itemNinja.position.y);
    
    priceForBiker = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForBiker.text = [NSString stringWithFormat:@"%d", bikerPrice];
    priceForBiker.fontSize = 30;
    priceForBiker.position = CGPointMake(0,  - priceForBiker.frame.size.height/2);
    
    [itemBiker addChild:priceForBiker];
    
    biker = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemBiker addChild:biker];
    
    
    return itemBiker;
}

- (SKSpriteNode *)itemTopHat {
    
    itemTopHat = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemTopHat.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemTopHat.position = CGPointMake(itemVampire.position.x,itemNinja.position.y);
    
    priceForTopHat = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForTopHat.text = [NSString stringWithFormat:@"%d", topHatPrice];
    priceForTopHat.fontSize = 30;
    priceForTopHat.position = CGPointMake(0,  - priceForTopHat.frame.size.height/2);
    
    [itemTopHat addChild:priceForTopHat];
    
    topHat = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemTopHat addChild:topHat];
    
    return itemTopHat;
}

- (SKSpriteNode *)itemPoliceMan {
    
    itemPoliceMan = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemPoliceMan.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemPoliceMan.position = CGPointMake(itemBlankPlayer.position.x, itemNinja.position.y - itemPoliceMan.size.height - self.frame.size.width/100);
    
    priceForPoliceMan = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForPoliceMan.text = [NSString stringWithFormat:@"%d", policeManPrice];
    priceForPoliceMan.fontSize = 30;
    priceForPoliceMan.position = CGPointMake(0,  - priceForPoliceMan.frame.size.height/2);
    
    [itemPoliceMan addChild:priceForPoliceMan];
    
    policeMan = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemPoliceMan addChild:policeMan];
    
    return itemPoliceMan;
}

- (SKSpriteNode *)itemBatman {
    
    itemBatman = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemBatman.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemBatman.position = CGPointMake(itemSmilingFace.position.x, itemPoliceMan.position.y);
    
    priceForBatman = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForBatman.text = [NSString stringWithFormat:@"%d", batmanPrice];
    priceForBatman.fontSize = 30;
    priceForBatman.position = CGPointMake(0,  - priceForBatman.frame.size.height/2);
    
    [itemBatman addChild:priceForBatman];
    
    batman = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemBatman addChild:batman];
    
    return itemBatman;
}

- (SKSpriteNode *)itemPirate {
    
    itemPirate = [SKSpriteNode spriteNodeWithImageNamed:@"StoreItemButtons"];
    
    itemPirate.size = CGSizeMake(self.frame.size.width/100*32, self.frame.size.width/100*16);
    itemPirate.position = CGPointMake(itemVampire.position.x, itemPoliceMan.position.y);
    
    priceForPirate = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    priceForPirate.text = [NSString stringWithFormat:@"%d", piratePrice];
    priceForPirate.fontSize = 30;
    priceForPirate.position = CGPointMake(0,  - priceForPirate.frame.size.height/2);
    
    [itemPirate addChild:priceForPirate];
    
    pirate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank.png"];
    
    [itemPirate addChild:pirate];
    
    return itemPirate;
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (pause == true) {
            
            //its loading - you cant click on any buttons
            
        } else {
        
        if ((location.x > returnToMenu.position.x - returnToMenu.frame.size.width/2 -self.frame.size.width/100*3) && (location.x < returnToMenu.position.x +returnToMenu.frame.size.width/2 + self.frame.size.width/100*3) && ( location.y > returnToMenu.position.y -returnToMenu.frame.size.height/2 -self.frame.size.width/100*3) && (location.y < returnToMenu.position.y + returnToMenu.frame.size.height/2 +self.frame.size.width/100*3)) { //clicked on play agin button
            
    
            [defaults setObject:playerOutiftName forKey:@"playerOutfit"];
            [defaults setInteger:gemAmount forKey:@"gemAmount"];
            [defaults synchronize];
            
            [self removeAllChildren];
            
             SKScene *gameOverScreen  = [[GameOverScreen alloc] initWithSize:self.size];
             SKTransition *appear = [SKTransition fadeWithDuration:0.2];
             [self.view presentScene:gameOverScreen transition:appear];
            
            
        } else if ((location.x > itemBlankPlayer.position.x - itemBlankPlayer.size.width/2 -self.frame.size.width/100) && (location.x < itemBlankPlayer.position.x +itemBlankPlayer.size.width/2 + self.frame.size.width/100) && ( location.y > itemBlankPlayer.position.y -itemBlankPlayer.size.height/2 -self.frame.size.width/100) && (location.y < itemBlankPlayer.position.y + itemBlankPlayer.size.height/2 +self.frame.size.width/100)) { //blank Player
            
                playerOutiftName = @"";
                
                [self makeShopItemsYellow];
                
                itemBlankPlayer.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
            
            
        } else if ((location.x > itemSmilingFace.position.x - itemSmilingFace.size.width/2 -self.frame.size.width/100) && (location.x < itemSmilingFace.position.x +itemSmilingFace.size.width/2 + self.frame.size.width/100) && ( location.y > itemSmilingFace.position.y -itemSmilingFace.size.height/2 -self.frame.size.width/100) && (location.y < itemSmilingFace.position.y + itemSmilingFace.size.height/2 +self.frame.size.width/100)) { //smilingface
            
            if (boughtSmilingFace == true) {
                playerOutiftName = @"SmilingFace";
                
                [self makeShopItemsYellow];
                
                itemSmilingFace.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];

            }else if (smilingFacePrice <= gemAmount) {
                
                gemAmount = gemAmount - smilingFacePrice;
                
                boughtSmilingFace = true;
                [defaults setBool:boughtSmilingFace forKey:@"boughtSmilingFace"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"SmilingFace";
                
                [self makeShopItemsYellow];
                
                itemSmilingFace.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                smilingFace.texture = [SKTexture textureWithImageNamed:@"SmilingFace.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForSmilingFace removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                     [SKAction runBlock:^{
                    itemSmilingFace.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemSmilingFace.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemBiker.position.x - itemBiker.size.width/2 -self.frame.size.width/100) && (location.x < itemBiker.position.x +itemBiker.size.width/2 + self.frame.size.width/100) && ( location.y > itemBiker.position.y -itemBiker.size.height/2 -self.frame.size.width/100) && (location.y < itemBiker.position.y + itemBiker.size.height/2 +self.frame.size.width/100)) { //biker
            
            if (boughtBiker == true) {
                playerOutiftName = @"Biker";
                
                [self makeShopItemsYellow];
                
                itemBiker.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                

            }else if (bikerPrice <= gemAmount) {
                
                gemAmount = gemAmount - bikerPrice;
                
                boughtBiker = true;
                [defaults setBool:boughtBiker forKey:@"boughtBiker"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Biker";
                
                [self makeShopItemsYellow];
                
                itemBiker.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                biker.texture = [SKTexture textureWithImageNamed:@"Biker.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForBiker removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemBiker.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemBiker.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemCyclops.position.x - itemCyclops.size.width/2 -self.frame.size.width/100) && (location.x < itemCyclops.position.x +itemCyclops.size.width/2 + self.frame.size.width/100) && ( location.y > itemCyclops.position.y -itemCyclops.size.height/2 -self.frame.size.width/100) && (location.y < itemCyclops.position.y + itemCyclops.size.height/2 +self.frame.size.width/100)) { //cyclops
            
            if (boughtCyclops == true) {
                playerOutiftName = @"Cyclops";
                
                [self makeShopItemsYellow];
                
                itemCyclops.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (cyclopsPrice <= gemAmount) {
                
                gemAmount = gemAmount - cyclopsPrice;
                
                boughtCyclops = true;
                [defaults setBool:boughtCyclops forKey:@"boughtCyclops"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Cyclops";
                
                [self makeShopItemsYellow];
                
                itemCyclops.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                cyclops.texture = [SKTexture textureWithImageNamed:@"Cyclops.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForCyclops removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemCyclops.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemCyclops.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemGlasses.position.x - itemGlasses.size.width/2 -self.frame.size.width/100) && (location.x < itemGlasses.position.x +itemGlasses.size.width/2 + self.frame.size.width/100) && ( location.y > itemGlasses.position.y -itemGlasses.size.height/2 -self.frame.size.width/100) && (location.y < itemGlasses.position.y + itemGlasses.size.height/2 +self.frame.size.width/100)) { //glasses
            
            if (boughtGlasses == true) {
                playerOutiftName = @"Glasses";
                
                [self makeShopItemsYellow];
                
                itemGlasses.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (glassesPrice <= gemAmount) {
                
                gemAmount = gemAmount - glassesPrice;
                
                boughtGlasses = true;
                [defaults setBool:boughtGlasses forKey:@"boughtGlasses"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Glasses";
                
                [self makeShopItemsYellow];
                
                itemGlasses.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                glasses.texture = [SKTexture textureWithImageNamed:@"Glasses.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForGlasses removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemGlasses.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemGlasses.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemTopHat.position.x - itemTopHat.size.width/2 -self.frame.size.width/100) && (location.x < itemTopHat.position.x +itemTopHat.size.width/2 + self.frame.size.width/100) && ( location.y > itemTopHat.position.y -itemTopHat.size.height/2 -self.frame.size.width/100) && (location.y < itemTopHat.position.y + itemTopHat.size.height/2 +self.frame.size.width/100)) { //top hat
            
            if (boughtTopHat == true) {
                playerOutiftName = @"TopHat";
                
                [self makeShopItemsYellow];
                
                itemTopHat.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (topHatPrice <= gemAmount) {
                
                gemAmount = gemAmount - topHatPrice;
                
                boughtTopHat = true;
                [defaults setBool:boughtTopHat forKey:@"boughtTopHat"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"TopHat";
                
                [self makeShopItemsYellow];
                
                itemTopHat.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                topHat.texture = [SKTexture textureWithImageNamed:@"TopHat.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForTopHat removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemTopHat.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemTopHat.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemVampire.position.x - itemVampire.size.width/2 -self.frame.size.width/100) && (location.x < itemVampire.position.x +itemVampire.size.width/2 + self.frame.size.width/100) && ( location.y > itemVampire.position.y -itemVampire.size.height/2 -self.frame.size.width/100) && (location.y < itemVampire.position.y + itemVampire.size.height/2 +self.frame.size.width/100)) { //vampire
            
            if (boughtVampire == true) {
                playerOutiftName = @"Vampire";
                
                [self makeShopItemsYellow];
                
                itemVampire.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (vampirePrice <= gemAmount) {
                
                gemAmount = gemAmount - vampirePrice;
                
                boughtVampire = true;
                [defaults setBool:boughtVampire forKey:@"boughtVampire"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Vampire";
                
                [self makeShopItemsYellow];
                
                itemVampire.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                vampire.texture = [SKTexture textureWithImageNamed:@"Vampire.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForVampire removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemVampire.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemVampire.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemNinja.position.x - itemNinja.size.width/2 -self.frame.size.width/100) && (location.x < itemNinja.position.x +itemNinja.size.width/2 + self.frame.size.width/100) && ( location.y > itemNinja.position.y -itemNinja.size.height/2 -self.frame.size.width/100) && (location.y < itemNinja.position.y + itemNinja.size.height/2 +self.frame.size.width/100)) { //ninja
            
            if (boughtNinja == true) {
                playerOutiftName = @"Ninja";
                
                [self makeShopItemsYellow];
                
                itemNinja.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (ninjaPrice <= gemAmount) {
                
                gemAmount = gemAmount - ninjaPrice;
                
                boughtNinja = true;
                [defaults setBool:boughtNinja forKey:@"boughtNinja"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Ninja";
                
                [self makeShopItemsYellow];
                
                itemNinja.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                ninja.texture = [SKTexture textureWithImageNamed:@"Ninja.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForNinja removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemNinja.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemNinja.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemAstronaut.position.x - itemAstronaut.size.width/2 -self.frame.size.width/100) && (location.x < itemAstronaut.position.x +itemAstronaut.size.width/2 + self.frame.size.width/100) && ( location.y > itemAstronaut.position.y -itemAstronaut.size.height/2 -self.frame.size.width/100) && (location.y < itemAstronaut.position.y + itemAstronaut.size.height/2 +self.frame.size.width/100)) { //astronaut
            
            if (boughtAstronaut == true) {
                playerOutiftName = @"Astronaut";
                
                [self makeShopItemsYellow];
                
                itemAstronaut.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (astronautPrice <= gemAmount) {
                
                gemAmount = gemAmount - astronautPrice;
                
                boughtAstronaut = true;
                [defaults setBool:boughtAstronaut forKey:@"boughtAstronaut"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Astronaut";
                
                [self makeShopItemsYellow];
                
                itemAstronaut.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                astronaut.texture = [SKTexture textureWithImageNamed:@"Astronaut.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForAstronaut removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemAstronaut.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemAstronaut.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemPoliceMan.position.x - itemPoliceMan.size.width/2 -self.frame.size.width/100) && (location.x < itemPoliceMan.position.x +itemPoliceMan.size.width/2 + self.frame.size.width/100) && ( location.y > itemPoliceMan.position.y -itemPoliceMan.size.height/2 -self.frame.size.width/100) && (location.y < itemPoliceMan.position.y + itemPoliceMan.size.height/2 +self.frame.size.width/100)) { //police man
            
            if (boughtPoliceMan == true) {
                playerOutiftName = @"PoliceMan";
                
                [self makeShopItemsYellow];
                
                itemPoliceMan.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (policeManPrice <= gemAmount) {
                
                gemAmount = gemAmount - policeManPrice;
                
                boughtPoliceMan = true;
                [defaults setBool:boughtPoliceMan forKey:@"boughtPoliceMan"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                
                playerOutiftName = @"PoliceMan";
                
                [self makeShopItemsYellow];
                
                itemPoliceMan.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                policeMan.texture = [SKTexture textureWithImageNamed:@"PoliceMan1.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForPoliceMan removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemPoliceMan.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemPoliceMan.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemBatman.position.x - itemBatman.size.width/2 -self.frame.size.width/100) && (location.x < itemBatman.position.x +itemBatman.size.width/2 + self.frame.size.width/100) && ( location.y > itemBatman.position.y -itemBatman.size.height/2 -self.frame.size.width/100) && (location.y < itemBatman.position.y + itemBatman.size.height/2 +self.frame.size.width/100)) { //batman
            
            if (boughtBatman == true) {
                playerOutiftName = @"Batman";
                
                [self makeShopItemsYellow];
                
                itemBatman.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (batmanPrice <= gemAmount) {
                
                gemAmount = gemAmount - batmanPrice;
                
                boughtBatman = true;
                [defaults setBool:boughtBatman forKey:@"boughtBatman"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Batman";
                
                [self makeShopItemsYellow];
                
                itemBatman.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                batman.texture = [SKTexture textureWithImageNamed:@"Batman.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForBatman removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemBatman.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemBatman.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemPirate.position.x - itemPirate.size.width/2 -self.frame.size.width/100) && (location.x < itemPirate.position.x +itemPirate.size.width/2 + self.frame.size.width/100) && ( location.y > itemPirate.position.y -itemPirate.size.height/2 -self.frame.size.width/100) && (location.y < itemPirate.position.y + itemPirate.size.height/2 +self.frame.size.width/100)) { //pirate
            
            if (boughtPirate == true) {
                playerOutiftName = @"Pirate";
                
                [self makeShopItemsYellow];
                
                itemPirate.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                
                
            }else if (piratePrice <= gemAmount) {
                
                gemAmount = gemAmount - piratePrice;
                
                boughtPirate = true;
                [defaults setBool:boughtPirate forKey:@"boughtPirate"];
                [defaults setInteger:gemAmount forKey:@"gemAmount"];
                
                playerOutiftName = @"Pirate";
                
                [self makeShopItemsYellow];
                
                itemPirate.texture = [SKTexture textureWithImageNamed:@"BlueStoreButtons.png"];
                pirate.texture = [SKTexture textureWithImageNamed:@"Pirate.png"];
                
                gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
                
                [priceForPirate removeFromParent];
                
            } else {
                flashRed = [SKAction sequence:@[
                                                          [SKAction runBlock:^{
                    itemPirate.texture = [SKTexture textureWithImageNamed:@"RedStoreButtons.png"];
                    [self runAction:[SKAction waitForDuration:0.1]completion:^{
                        itemPirate.texture = [SKTexture textureWithImageNamed:@"StoreItemButtons.png"];
                    }];
                }]]];
                [self runAction:flashRed];
            }
            
        } else if ((location.x > itemMoreGems.position.x - itemMoreGems.size.width/2 -self.frame.size.width/100) && (location.x < itemMoreGems.position.x +itemMoreGems.size.width/2 + self.frame.size.width/100) && ( location.y > itemMoreGems.position.y -itemMoreGems.size.height/2 -self.frame.size.width/100) && (location.y < itemMoreGems.position.y + itemMoreGems.size.height/2 +self.frame.size.width/100)) { //item More Gems (buy more gems) - premium currency
            
            
            [defaults setObject:playerOutiftName forKey:@"playerOutfit"];
            [defaults setInteger:gemAmount forKey:@"gemAmount"];
            [defaults synchronize];
            
            [self removeAllChildren];
            
            SKScene *premiumStoreScreen  = [[PremiumStoreScreen alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:premiumStoreScreen transition:appear];

            
            
        } else if ((location.x > item2xGems.position.x - item2xGems.size.width/2 -self.frame.size.width/100) && (location.x < item2xGems.position.x +item2xGems.size.width/2 + self.frame.size.width/100) && ( location.y > item2xGems.position.y -item2xGems.size.height/2 -self.frame.size.width/100) && (location.y < item2xGems.position.y + item2xGems.size.height/2 +self.frame.size.width/100)) { //item2xGems - premium currency
            
            if ([[InAppManager sharedManager]isFeature1PurchasedAlready] == NO) {
                
                [[InAppManager sharedManager]buyFeature1];
                item2xGems.texture = [SKTexture textureWithImageNamed:@"SelectedLongStoreItemButtons.png"];
                [self addLoadingScreen];
                
                [self runAction:[SKAction waitForDuration:10] completion:^{
                    
                    if( [[InAppManager sharedManager] isFeature1PurchasedAlready] == YES) {
                        item2xGems.texture = [SKTexture textureWithImageNamed:@"LongBlueStoreItemButtons.png"];
                        
                    } else {
                        item2xGems.texture = [SKTexture textureWithImageNamed:@"LongStoreItemButtons.png"];
                        
                        //takes away the loading screen
                        [greyFadedBackground removeFromParent];
                        pause = false;
                    }
                }];
                
                
            }else {
                
            }
            
            
        }



        
    }
    
    }
    
    
}



-(void) makeShopItemsYellow {
    
    itemBlankPlayer.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
    
    if (boughtSmilingFace == true) {
        itemSmilingFace.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];

    }
    
    if (boughtBiker == true) {
        itemBiker.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];

    }
    
    if (boughtCyclops == true) {
        itemCyclops.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];

    }
    
    if (boughtNinja == true) {
        itemNinja.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }
    
    
    if (boughtGlasses == true) {
        itemGlasses.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }
    
    if (boughtTopHat == true) {
        itemTopHat.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }
    
    if (boughtAstronaut == true) {
        itemAstronaut.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }
    
    if (boughtVampire== true) {
        itemVampire.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }
    
    if (boughtPoliceMan == true) {
        itemPoliceMan.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }
    
    if (boughtBatman == true) {
        itemBatman.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }
    
    if (boughtPirate == true) {
        itemPirate.texture = [SKTexture textureWithImageNamed:@"YellowStoreButtons.png"];
        
    }

    
    
}

-(void)unlockProduct1 {
    
    NSLog(@"Our class knows that we unlocked Product 1");
    //do whatever you want from unlocking the product
    //(gem doubler)
    //not needed at all - it is just defined in gamescene.m when coins are colected
    
    [defaults setBool:true forKey:@"gemDoublerIsOn"];
    [defaults synchronize];
    
    //takes away the loading screen
    [greyFadedBackground removeFromParent];
    pause = false;
    
}

@end
