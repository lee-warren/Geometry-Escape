//
//  PremiumStoreScreen.m
//  Geometry Escape
//
//  Created by Lee Warren on 12/01/2015.
//  Copyright (c) 2015 Lee Warren. All rights reserved.
//

#import "PremiumStoreScreen.h"
#import "InAppManager.h"
#import "StoreScreen.h"

@interface PremiumStoreScreen ()
@property BOOL contentCreated;
@end

@implementation PremiumStoreScreen


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
    
    gemAmount = (int)[defaults integerForKey:@"gemAmount"];
    //playerOutiftName = [defaults stringForKey:@"playerOutfit"];
    
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct2) name:@"feature2Purchased" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct3) name:@"feature3Purchased" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct4) name:@"feature4Purchased" object:nil];

    
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

- (void) addShopItems {
    
    [self addChild: [self  itemSmallGemPack]];
    
    itemSmallGemPackDescription = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    itemSmallGemPackDescription.text = [NSString stringWithFormat:@"+250 Gems $%.02f",(double)[defaults doubleForKey:@"priceOfProduct3"]];
    itemSmallGemPackDescription.fontSize = 30;
    itemSmallGemPackDescription.position = CGPointMake(0,  - itemSmallGemPackDescription.frame.size.height/2);
    
    [itemSmallGemPack addChild:itemSmallGemPackDescription];
    
    
    
    [self addChild: [self  itemMediumGemPack]];
    
    itemMediumGemPackDescription = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    itemMediumGemPackDescription.text = [NSString stringWithFormat:@"+750 Gems $%.02f",(double)[defaults doubleForKey:@"priceOfProduct2"]];
    itemMediumGemPackDescription.fontSize = 32;
    itemMediumGemPackDescription.position = CGPointMake(0,  - itemMediumGemPackDescription.frame.size.height/2);
    
    [itemMediumGemPack addChild:itemMediumGemPackDescription];
    
    
    
    [self addChild: [self  itemLargeGemPack]];
    
    itemLargeGemPackDescription = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    itemLargeGemPackDescription.text = [NSString stringWithFormat:@"+2000 Gems $%.02f",(double)[defaults doubleForKey:@"priceOfProduct1"]];
    itemLargeGemPackDescription.fontSize = 35;
    itemLargeGemPackDescription.position = CGPointMake(0,  - itemLargeGemPackDescription.frame.size.height/2);
    
    [itemLargeGemPack addChild:itemLargeGemPackDescription];
    
    
    //premium purchase - 2xgems
    [self addChild: [self  item2xGems]];
    
    if ([[InAppManager sharedManager]isFeature1PurchasedAlready] == YES) {
        
        item2xGems.texture = [SKTexture textureWithImageNamed:@"LongBlueStoreItemButtons.png"];
    }
    
}

- (SKSpriteNode *)itemSmallGemPack {
    
    itemSmallGemPack = [SKSpriteNode spriteNodeWithImageNamed:@"LongStoreItemButtons"];
    
    itemSmallGemPack.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    itemSmallGemPack.position = CGPointMake(self.frame.size.width/100 + itemSmallGemPack.size.width/2, self.frame.size.height/4*3);
    
    
    
    return itemSmallGemPack;
    
}

- (SKSpriteNode *)itemMediumGemPack {
    
    itemMediumGemPack = [SKSpriteNode spriteNodeWithImageNamed:@"LongStoreItemButtons"];
    
    itemMediumGemPack.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    itemMediumGemPack.position = CGPointMake(itemSmallGemPack.position.x, itemSmallGemPack.position.y - itemMediumGemPack.size.height - self.frame.size.width/100);
    
    
    
    return itemMediumGemPack;
    
}

- (SKSpriteNode *)itemLargeGemPack {
    
    itemLargeGemPack = [SKSpriteNode spriteNodeWithImageNamed:@"LongStoreItemButtons"];
    
    itemLargeGemPack.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    itemLargeGemPack.position = CGPointMake(itemSmallGemPack.position.x, itemMediumGemPack.position.y - itemLargeGemPack.size.height - self.frame.size.width/100);
    
    
    
    
    
    return itemLargeGemPack;
    
}

- (SKSpriteNode *)item2xGems {
    
    item2xGems = [SKSpriteNode spriteNodeWithImageNamed:@"LongStoreItemButtons"];
    
    item2xGems.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    item2xGems.position = CGPointMake(self.frame.size.width/100 + item2xGems.size.width/2, item2xGems.size.height*3 + self.frame.size.width/100*2);
    
    item2xGemsDescription = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    item2xGemsDescription.text = [NSString stringWithFormat:@"Gem Doubler $%.02f",(double)[defaults doubleForKey:@"priceOfProduct0"]];
    item2xGemsDescription.fontSize = 30;
    item2xGemsDescription.position = CGPointMake(0,  - item2xGemsDescription.frame.size.height/2);
    
    [item2xGems addChild:item2xGemsDescription];
    
    return item2xGems;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ((location.x > returnToMenu.position.x - returnToMenu.frame.size.width/2 -self.frame.size.width/100*3) && (location.x < returnToMenu.position.x +returnToMenu.frame.size.width/2 + self.frame.size.width/100*3) && ( location.y > returnToMenu.position.y -returnToMenu.frame.size.height/2 -self.frame.size.width/100*3) && (location.y < returnToMenu.position.y + returnToMenu.frame.size.height/2 +self.frame.size.width/100*3)) { //clicked on play agin button
            
            
            [defaults setInteger:gemAmount forKey:@"gemAmount"];
            [defaults synchronize];
            
            [self removeAllChildren];
            
            SKScene *storeScreen  = [[StoreScreen alloc] initWithSize:self.size];
            SKTransition *appear = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:storeScreen transition:appear];
            
            
        } else if ((location.x > itemSmallGemPack.position.x - itemSmallGemPack.size.width/2 -self.frame.size.width/100) && (location.x < itemSmallGemPack.position.x +itemSmallGemPack.size.width/2 + self.frame.size.width/100) && ( location.y > itemSmallGemPack.position.y -itemSmallGemPack.size.height/2 -self.frame.size.width/100) && (location.y < itemSmallGemPack.position.y + itemSmallGemPack.size.height/2 +self.frame.size.width/100)) { //itemSmallGemPack - premium currency
                
            [[InAppManager sharedManager]buyFeature2]; //feature 2 = small gem pack
            [self addLoadingScreen];
            flashGreen = [SKAction sequence:@[
                                            [SKAction runBlock:^{
                itemSmallGemPack.texture = [SKTexture textureWithImageNamed:@"SelectedLongStoreItemButtons.png"];
                [self runAction:[SKAction waitForDuration:7]completion:^{
                    itemSmallGemPack.texture = [SKTexture textureWithImageNamed:@"LongStoreItemButtons.png"];
                    
                    //takes away the loading screen
                    [greyFadedBackground removeFromParent];
                    pause = false;
                    
                }];
            }]]];
            [self runAction:flashGreen];

            
            
        }else if ((location.x > itemMediumGemPack.position.x - itemMediumGemPack.size.width/2 -self.frame.size.width/100) && (location.x < itemMediumGemPack.position.x +itemMediumGemPack.size.width/2 + self.frame.size.width/100) && ( location.y > itemMediumGemPack.position.y -itemMediumGemPack.size.height/2 -self.frame.size.width/100) && (location.y < itemMediumGemPack.position.y + itemMediumGemPack.size.height/2 +self.frame.size.width/100)) { //itemMediumGemPack - premium currency
            
            [[InAppManager sharedManager]buyFeature3]; //feature 2 = medium gem pack
            [self addLoadingScreen];
            flashGreen = [SKAction sequence:@[
                                            [SKAction runBlock:^{
                itemMediumGemPack.texture = [SKTexture textureWithImageNamed:@"SelectedLongStoreItemButtons.png"];
                [self runAction:[SKAction waitForDuration:7]completion:^{
                    itemMediumGemPack.texture = [SKTexture textureWithImageNamed:@"LongStoreItemButtons.png"];
                    
                    //takes away the loading screen
                    [greyFadedBackground removeFromParent];
                    pause = false;
                }];
            }]]];
            [self runAction:flashGreen];
            
            
            
        }else if ((location.x > itemLargeGemPack.position.x - itemLargeGemPack.size.width/2 -self.frame.size.width/100) && (location.x < itemLargeGemPack.position.x +itemLargeGemPack.size.width/2 + self.frame.size.width/100) && ( location.y > itemLargeGemPack.position.y -itemLargeGemPack.size.height/2 -self.frame.size.width/100) && (location.y < itemLargeGemPack.position.y + itemLargeGemPack.size.height/2 +self.frame.size.width/100)) { //itemLargeGemPack - premium currency
            
            [[InAppManager sharedManager]buyFeature4]; //feature 2 = large gem pack
            [self addLoadingScreen];
            flashGreen = [SKAction sequence:@[
                                            [SKAction runBlock:^{
                itemLargeGemPack.texture = [SKTexture textureWithImageNamed:@"SelectedLongStoreItemButtons.png"];
                [self runAction:[SKAction waitForDuration:7]completion:^{
                    itemLargeGemPack.texture = [SKTexture textureWithImageNamed:@"LongStoreItemButtons.png"];
                    
                    //takes away the loading screen
                    [greyFadedBackground removeFromParent];
                    pause = false;
                }];
            }]]];
            [self runAction:flashGreen];
            
            
            
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

-(void)unlockProduct2 {
    
    NSLog(@"Our class knows that we unlocked Product 2");
    //do whatever you want from unlocking the product
    //BOUGHT 250 GEMS
    
    gemAmount = gemAmount + 250;
    
    [defaults setInteger:gemAmount forKey:@"gemAmount"];
    [defaults synchronize];

    itemSmallGemPack.texture = [SKTexture textureWithImageNamed:@"LongStoreItemButtons.png"];
    gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
    gemAmountLabel.position = CGPointMake(gem.position.x - gemAmountLabel.frame.size.width/2 - gem.frame.size.width/2 - self.frame.size.width/100*2, gem.position.y - gemAmountLabel.frame.size.height/2);
    
    //takes away the loading screen
    [greyFadedBackground removeFromParent];
    pause = false;

}

-(void)unlockProduct3 {
    
    NSLog(@"Our class knows that we unlocked Product 3");
    //do whatever you want from unlocking the product
    //BOUGHT 750 GEMS
    
    gemAmount = gemAmount + 750;
    
    [defaults setInteger:gemAmount forKey:@"gemAmount"];
    [defaults synchronize];
    
    itemMediumGemPack.texture = [SKTexture textureWithImageNamed:@"LongStoreItemButtons.png"];
    gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
    gemAmountLabel.position = CGPointMake(gem.position.x - gemAmountLabel.frame.size.width/2 - gem.frame.size.width/2 - self.frame.size.width/100*2, gem.position.y - gemAmountLabel.frame.size.height/2);
    
    //takes away the loading screen
    [greyFadedBackground removeFromParent];
    pause = false;

}

-(void)unlockProduct4 {
    
    NSLog(@"Our class knows that we unlocked Product 4");
    //do whatever you want from unlocking the product
    //BOUGHT 2000 GEMS
    
    gemAmount = gemAmount + 2000;
    
    [defaults setInteger:gemAmount forKey:@"gemAmount"];
    [defaults synchronize];
    
    itemLargeGemPack.texture = [SKTexture textureWithImageNamed:@"LongStoreItemButtons.png"];
    gemAmountLabel.text = [NSString stringWithFormat:@"%d",gemAmount];
    gemAmountLabel.position = CGPointMake(gem.position.x - gemAmountLabel.frame.size.width/2 - gem.frame.size.width/2 - self.frame.size.width/100*2, gem.position.y - gemAmountLabel.frame.size.height/2);
    
    //takes away the loading screen
    [greyFadedBackground removeFromParent];
    pause = false;

}



@end
