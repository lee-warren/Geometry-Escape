//
//  GameScene.m
//  AvoidTheSquares - iOS
//
//  Created by Lee Warren on 3/12/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//


// https://color.adobe.com/create/color-wheel/?base=2&rule=Analogous&selected=0&name=My%20Color%20Theme&mode=rgb&rgbvalues=0.42914542626647834,0.5156218157642996,1,0.3188059330804909,0.91,0.6227047792433287,1,0.9843764727108347,0.40033619019834166,0.91,0.6638673052339695,0.47984958166383423,0.9986825173891246,0.39067316266713736,1&swatchOrder=0,1,2,3,4


#import "GameScene.h"
#import "GameOverScreen.h"
#import "InAppManager.h"
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
@import AVFoundation;

@interface GameScene ()
@property BOOL contentCreated;
@end

@implementation GameScene

static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t blockCategory = 0x1 << 1;
static const uint32_t gemCategory = 0x1 << 2;


- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        
        //Sends message to viewcontroller to hide ad.
        
        self.physicsWorld.contactDelegate = self;
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1.0f];

    //self.scaleMode = SKSceneScaleModeAspectFill;
        
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    locationOfPlayer = CGPointMake(self.size.width/2, self.size.height/4*3);
    speed = 2;
    score = 0;
    gemCount = 0;
    playerOutiftName = [defaults stringForKey:@"playerOutfit"];
    dontShowTutorial = [defaults boolForKey:@"dontShowTutorial"];

    //tutorial stuff
    
    if (dontShowTutorial == false) { //do show tutorial
        
        [self tutorialButtons];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMusic" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayMenuMusic" object:nil];


        
    } else { //dont show tutorial
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMusic" object:nil];
        [self runAction:[SKAction playSoundFileNamed:@"Alive Sound.mp3" waitForCompletion:YES]completion:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayGameMusic" object:nil];
        }];
        
            }

    
    //score label
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    scoreLabel.fontSize = 160;
    scoreLabel.fontColor = [SKColor colorWithRed:255/255.0f green:251/255.0f blue:102/255.0f alpha:1.0f];
    scoreLabel.text = [NSString stringWithFormat:@"0"];
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height
                                      /4 - scoreLabel.frame.size.height/2);
    scoreLabel.text = [NSString stringWithFormat:@""];
    scoreLabel.zPosition = 1.0;
    [self addChild:scoreLabel];
    
    
    //making the player
    player = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
    
    player.position = locationOfPlayer;
    player.size = CGSizeMake(self.frame.size.width/11 , self.frame.size.width/11);
    //player.scale = 0.1;
    player.name = @"player";

    //collision stuff
    player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.height / 2];
    player.physicsBody.dynamic = YES;
    player.physicsBody.categoryBitMask = playerCategory;
    
    //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    //[player runAction:[SKAction repeatActionForever:action]];
    
    [self addChild:player];
    
    //make the hand that explains the game
    hand = [SKSpriteNode spriteNodeWithImageNamed:@"hand1"];
    
    hand.position = CGPointMake(self.size.width/2, self.size.height/4);
    
    hand.size = CGSizeMake(self.frame.size.width/3 , self.frame.size.height/4);
    
    SKAction *handaction =[SKAction sequence: @[[SKAction moveToY:self.size.height/4 + 30 duration:1.1 ], [SKAction moveToY:self.size.height/4 - 30 duration:1.1]]];
    
    [hand runAction:[SKAction repeatActionForever: handaction]];
    
    [self addChild:hand];
    
    if (dontShowTutorial == false) { //do show tutorial
        [hand setHidden:YES];
        
    } else { //dont show tutorial
        //do nothing
    }
    
    //background for the bottom half of the screen
    SKShapeNode *topHalfOfScreenColour= [SKShapeNode shapeNodeWithRect:CGRectMake(0, self.size.height/2 - 1, self.frame.size.width, self.frame.size.height/2) cornerRadius:1];
    topHalfOfScreenColour.lineWidth = 1;
    topHalfOfScreenColour.fillColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1];

    [self addChild:topHalfOfScreenColour];
    
    
    //making the enemies (blocks)
    
    //block1 - top left
    block1 = [[SKSpriteNode alloc] initWithImageNamed:@"OtherRectangleEnemy.png" ];
    block1.size=CGSizeMake(self.frame.size.width/3.2 , self.frame.size.height/22.72);
    block1.zPosition = 1;
    block1.name = @"block";
    
    block1.position = CGPointMake(block1.frame.size.width/2, self.frame.size.height - block1.frame.size.height/2); //top left
    
    //collision stuff
    block1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(block1.frame.size.width , block1.frame.size.height)]; // same as its original size
    block1.physicsBody.usesPreciseCollisionDetection = YES;
    block1.physicsBody.dynamic = YES;
    block1.physicsBody.categoryBitMask = blockCategory;
    
    block1.physicsBody.collisionBitMask = 0;
    block1.physicsBody.contactTestBitMask = blockCategory | playerCategory;
    
    [self addChild:block1];
    
    //block2 - top right
    block2 = [[SKSpriteNode alloc] initWithImageNamed:@"RectangleEnemy.png" ];
    block2.size=CGSizeMake(self.frame.size.width/5.3 , self.frame.size.height/14.2);
    block2.zPosition = 1;
    block2.name = @"block";
    
    block2.position = CGPointMake(self.frame.size.width - block2.frame.size.width/2, self.frame.size.height - block2.frame.size.height/2); //top right
    
    //collision stuff
    block2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(block2.frame.size.width , block2.frame.size.height)]; // same as its original size
    block2.physicsBody.usesPreciseCollisionDetection = YES;
    block2.physicsBody.dynamic = YES;
    block2.physicsBody.categoryBitMask = blockCategory;
    
    block2.physicsBody.collisionBitMask = 0;
    block2.physicsBody.contactTestBitMask = blockCategory | playerCategory;
    
    [self addChild:block2];
    
    //block3 - bottom left
    block3 = [[SKSpriteNode alloc] initWithImageNamed:@"SquareEnemy1.png" ];
    block3.size=CGSizeMake(self.frame.size.width/7.8 , self.frame.size.width/7.8);
    block3.zPosition = 1;
    block3.name = @"block";
    
    block3.position = CGPointMake(block3.frame.size.width/2, self.frame.size.height/2 + block3.frame.size.height/2); //bottom left
    
    //collision stuff
    block3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(block3.frame.size.width , block3.frame.size.height)]; // same as its original size
    block3.physicsBody.usesPreciseCollisionDetection = YES;
    block3.physicsBody.dynamic = YES;
    block3.physicsBody.categoryBitMask = blockCategory;
    
    block3.physicsBody.collisionBitMask = 0;
    block3.physicsBody.contactTestBitMask = blockCategory | playerCategory;
    
    [self addChild:block3];
    
    //block4 - bottom right
    block4 = [[SKSpriteNode alloc] initWithImageNamed:@"SquareEnemy1.png" ];
    block4.size=CGSizeMake(self.frame.size.width/7.8 , self.frame.size.width/7.8);
    block4.zPosition = 1;
    block4.name = @"block";
    
    block4.position = CGPointMake(self.frame.size.width - block4.frame.size.width/2, self.frame.size.height/2 + block4.frame.size.height/2); //bottom right
    
    //collision stuff
    block4.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(block4.frame.size.width , block4.frame.size.height)]; // same as its original size
    block4.physicsBody.usesPreciseCollisionDetection = YES;
    block4.physicsBody.dynamic = YES;
    block4.physicsBody.categoryBitMask = blockCategory;
    
    block4.physicsBody.collisionBitMask = 0;
    block4.physicsBody.contactTestBitMask = blockCategory | playerCategory;
    
    [self addChild:block4];
    
    /*
    NSMutableArray *texturesForBlock4 = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 1; i < 3; i++)
    {
        NSString *textureNameBlock4 = [NSString stringWithFormat:@"squareEnemy%d.png", i];
        SKTexture *textureBlock4 =
        [SKTexture textureWithImageNamed:textureNameBlock4];
        [texturesForBlock4 addObject:textureBlock4];
    }
    
    SKAction* spriteAnimationBlock4 = [SKAction animateWithTextures:texturesForBlock4 timePerFrame:0.2];
    
    SKAction *repeatBlock4 = [SKAction repeatActionForever:spriteAnimationBlock4];
    [block4 runAction:repeatBlock4];
    */
    
    //
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
    
    
    
    //make the first coin
    gem = [[SKSpriteNode alloc] initWithImageNamed:@"gem1.png"];
    gem.zPosition = 1;
    gem.size=CGSizeMake(self.frame.size.width/11 , self.frame.size.width/11);
    gem.name = @"gem";
    
    gemXValue = arc4random_uniform(self.frame.size.width - gem.size.width*2) + gem.size.width;
    gemYValue = arc4random_uniform(self.frame.size.height/2 - gem.size.height*2) + self.frame.size.height/2 + gem.size.height;
    gem.position = CGPointMake(gemXValue, gemYValue);
    
    //collision stuff
    gem.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:gem.size.height / 2]; // same as its original size
    gem.physicsBody.usesPreciseCollisionDetection = YES;
    gem.physicsBody.dynamic = YES;
    gem.physicsBody.categoryBitMask = gemCategory;
    
    gem.physicsBody.collisionBitMask = 0;
    gem.physicsBody.contactTestBitMask = gemCategory | playerCategory;
    
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
    
    
    //
    
}

-(void) makeNewGem {
    
    [self runAction:[SKAction waitForDuration:1.5] completion:^ {
        
        gem = [[SKSpriteNode alloc] initWithImageNamed:@"gem1.png" ];
        gem.zPosition = 1;
        
        gem.size=CGSizeMake(self.frame.size.width/11 , self.frame.size.width/11);
        
        gemXValue = arc4random_uniform(self.frame.size.width - gem.size.width*2) + gem.size.width;
        gemYValue = arc4random_uniform(self.frame.size.height/2 - gem.size.height*2) + self.frame.size.height/2 + gem.size.height;
        gem.position = CGPointMake(gemXValue, gemYValue);
        
        gem.name = @"gem";
        
        //collision stuff
        gem.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:gem.size.height / 2]; // same as its original size
        gem.physicsBody.usesPreciseCollisionDetection = YES;
        gem.physicsBody.dynamic = YES;
        gem.physicsBody.categoryBitMask = gemCategory;
        
        gem.physicsBody.collisionBitMask = 0;
        gem.physicsBody.contactTestBitMask = gemCategory | playerCategory;
        
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
    }];
    
    
}

//tutorial stuff
-(void)tutorialButtons {
    
    [self addChild: [self playTutorialButton]];
    [self addChild: [self dontPlayTutorialButton]];
    
    //label that informs the user that this is their first time
    TutorialHelpText = [SKNode node];
    SKLabelNode *lineA = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    lineA.fontSize = 35;
    lineA.fontColor = [SKColor whiteColor];
    SKLabelNode *lineB = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    lineB.fontSize = 35;
    lineB.fontColor = [SKColor whiteColor];
    SKLabelNode *lineC = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    lineC.fontSize = 35;
    lineC.fontColor = [SKColor whiteColor];
    SKLabelNode *lineD = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    lineD.fontSize = 35;
    lineD.fontColor = [SKColor whiteColor];
    NSString *st1 = @"Welcome To";
    NSString *st2 = @"Geometry Escape";
    NSString *st3 = @"Would You Like To ";
    NSString *st4 = @"View The Tutorial?";
    lineB.position = CGPointMake(lineB.position.x, lineA.position.y - 20);
    lineC.position = CGPointMake(lineC.position.x, lineB.position.y - 20);
    lineD.position = CGPointMake(lineD.position.x, lineC.position.y - 20);
    lineA.text = st1;
    lineB.text = st2;
    lineC.text = st3;
    lineD.text = st4;
    [TutorialHelpText addChild:lineA];
    [TutorialHelpText addChild:lineB];
    [TutorialHelpText addChild:lineC];
    [TutorialHelpText addChild:lineD];
    TutorialHelpText.position = CGPointMake(self.size.width/2 - TutorialHelpText.frame.size.width/2, playTutorialButton.position.y + dontPlayTutorialButton.size.height/2*5);
    
    [self addChild:TutorialHelpText];
    
}
- (SKSpriteNode *)playTutorialButton { //for tutorial
    
    playTutorialButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayAgainButton"];
    
    playTutorialButton.size = CGSizeMake(self.frame.size.width/100*48, self.frame.size.width/100*16);
    playTutorialButton.position = CGPointMake(self.frame.size.width/100 + playTutorialButton.size.width/2, self.frame.size.height/6);
    
    SKLabelNode *theWordsPlayTutorial = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsPlayTutorial.text = @"Watch Tutorial";
    theWordsPlayTutorial.fontSize = 20;
    theWordsPlayTutorial.position = CGPointMake(0,  - theWordsPlayTutorial.frame.size.height/2);
    
    [playTutorialButton addChild:theWordsPlayTutorial];
    playTutorialButton.zPosition = 3;
    
    return playTutorialButton;
}
- (SKSpriteNode *)dontPlayTutorialButton { //for tutorial
    
    dontPlayTutorialButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayAgainButton"];
    
    dontPlayTutorialButton.size = CGSizeMake(self.frame.size.width/100*48, self.frame.size.width/100*16);
    dontPlayTutorialButton.position = CGPointMake(playTutorialButton.position.x + self.frame.size.width/100*2 + dontPlayTutorialButton.size.width, self.frame.size.height/6);
    
    theWordsDontPlayTutorial = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsDontPlayTutorial.text = @"Skip Tutorial";
    theWordsDontPlayTutorial.fontSize = 20;
    theWordsDontPlayTutorial.position = CGPointMake(0,  - theWordsDontPlayTutorial.frame.size.height/2);
    
    [dontPlayTutorialButton addChild:theWordsDontPlayTutorial];
    dontPlayTutorialButton.zPosition = 3;
    
    return dontPlayTutorialButton;
}

-(void)setupTutorial {
    
    fileURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"App Tutorial" ofType:@"mp4"]];
    
    _player = [AVPlayer playerWithURL: fileURL];
    //_player.rate = 0.5;
    
    CMTime duration = _player.currentItem.asset.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    tutorial = [[SKVideoNode alloc] initWithAVPlayer:_player];
    tutorial.size = CGSizeMake(self.size.width, self.size.height);
    tutorial.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    [self addChild:tutorial];
    
    _player.volume = 0;
    
    tutorial.zPosition = 2;

    [tutorial play];
    
    
    [self runAction:[SKAction waitForDuration:seconds] completion:^ {
        
        [tutorial removeFromParent];
        
        [hand setHidden:YES];
        [self addChild: [self playButton]];
        
    }];
    
    
}
//

- (SKSpriteNode *)playButton { //for tutorial
    
    playButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayAgainButton"];
    
    playButton.size = CGSizeMake(self.frame.size.width/100*98, self.frame.size.width/100*16);
    playButton.position = CGPointMake(self.frame.size.width/100 + playButton.size.width/2, self.frame.size.height/6);
    
    SKLabelNode *theWordsPlay = [SKLabelNode labelNodeWithFontNamed:@"Acknowledge TT (BRK)"];
    theWordsPlay.text = @"Ok. Lets Play!";
    theWordsPlay.fontSize = 30;
    theWordsPlay.position = CGPointMake(0,  - theWordsPlay.frame.size.height/2);
    
    [playButton addChild:theWordsPlay];
    playButton.zPosition = 3;
    
    return playButton;
}


//collisions
- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    //collision between player and block
    if ((contact.bodyA.categoryBitMask == blockCategory)
        && (contact.bodyB.categoryBitMask == playerCategory)) {
        
        [self youDied];
        
    }
    
    //collision between player and coin
    if ((contact.bodyA.categoryBitMask == playerCategory)
        && (contact.bodyB.categoryBitMask == gemCategory)) {
        
        //you collected a coin
        if ([[InAppManager sharedManager]isFeature1PurchasedAlready] == YES) {
            gemCount = gemCount + 2;
        } else {
            gemCount = gemCount + 1;

        }
        
        [self runAction:[SKAction playSoundFileNamed:@"CollectCoin.wav" waitForCompletion:YES]];
        
        [self runAction: [SKAction performSelector:@selector(makeNewGem) onTarget:self]];
        
        //checks to see if the first or second object was the coin and removes the coin
        if([contact.bodyA.node.name isEqualToString:@"gem"] )
        {
            [contact.bodyA.node removeFromParent];
        }else{
            [contact.bodyB.node removeFromParent];
        }
         
        
    }
    
}


/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
       CGPoint location = [touch locationInNode:self];
        NSLog(@"%f , %f", location.x,location.y);
    }
}
*/


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        if (dontShowTutorial == false) { //do show tutorial
            
            
        } else { //not showing tutorial
            
            //moves the player if they touched in the bottom half of the screen
            if ([touch locationInNode:self].y < self.size.height/2) {
                
                locationOfFinger = [touch locationInNode:self];
                
                locationOfPlayer = player.position;
                
            }
        }
        
        
    }
}



- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        
        if (dontShowTutorial == false) { //do show tutorial
            
            
        } else { //not showing tutorial
            
            locationOfFingerNow = [touch locationInNode:self];
            
            if (gameOn == false) {
                
                locationOfPlayerNow = player.position;
                
                [hand runAction: [SKAction fadeAlphaTo:0 duration:0.5] completion:^ {
                    [hand removeFromParent];
                }];
                
                gameOn = true;
            }
            //moves the player if they touched in the bottom half of the screen
            if (locationOfFingerNow.y < self.size.height/2) {
                
                locationOfPlayerNow = CGPointMake(1.25*(locationOfFingerNow.x - locationOfFinger.x) + locationOfPlayer.x, 1.25*(locationOfFingerNow.y - locationOfFinger.y) + locationOfPlayer.y);
                
                
            }
            
        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ((location.x > playTutorialButton.position.x - playTutorialButton.size.width/2 -self.frame.size.width/100) && (location.x < playTutorialButton.position.x +playTutorialButton.size.width/2 + self.frame.size.width/100) && ( location.y > playTutorialButton.position.y -playTutorialButton.size.height/2 -self.frame.size.width/100) && (location.y < playTutorialButton.position.y + playTutorialButton.size.height/2 +self.frame.size.width/100)) { //clicked on playTutorialButton
    
            [self setupTutorial];
            playTutorialButton.position = CGPointMake(-500, -50);
            dontPlayTutorialButton.position = CGPointMake(-500, -50);
            [TutorialHelpText removeFromParent];
            [playTutorialButton removeFromParent];
            [dontPlayTutorialButton removeFromParent];

        } else if ((location.x > dontPlayTutorialButton.position.x - dontPlayTutorialButton.size.width/2 -self.frame.size.width/100) && (location.x < dontPlayTutorialButton.position.x +dontPlayTutorialButton.size.width/2 + self.frame.size.width/100) && ( location.y > dontPlayTutorialButton.position.y -dontPlayTutorialButton.size.height/2 -self.frame.size.width/100) && (location.y < dontPlayTutorialButton.position.y + dontPlayTutorialButton.size.height/2 +self.frame.size.width/100)) { //clicked on dontPlayTutorialButton
            
            dontPlayTutorialButton.position = CGPointMake(-500, -50);
            playTutorialButton.position = CGPointMake(-500, -50);
            [TutorialHelpText removeFromParent];
            [dontPlayTutorialButton removeFromParent];
            [playTutorialButton removeFromParent];
            
            [hand setHidden:NO];
            
            dontShowTutorial = true;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMusic" object:nil];
            [self runAction:[SKAction playSoundFileNamed:@"Alive Sound.mp3" waitForCompletion:YES]completion:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayGameMusic" object:nil];
            }];
            
        } else if ((location.x > playButton.position.x - playButton.size.width/2 -self.frame.size.width/100) && (location.x < playButton.position.x +playButton.size.width/2 + self.frame.size.width/100) && ( location.y > playButton.position.y -playButton.size.height/2 -self.frame.size.width/100) && (location.y < playButton.position.y + playButton.size.height/2 +self.frame.size.width/100)) { //clicked on play button
            
            playButton.position = CGPointMake(-500, -50);
            [playButton removeFromParent];

            [hand setHidden:NO];
            
            dontShowTutorial = true;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMusic" object:nil];
            [self runAction:[SKAction playSoundFileNamed:@"Alive Sound.mp3" waitForCompletion:YES]completion:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayGameMusic" object:nil];
            }];


        }
    }
    
}

/*
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        
        locationOfFinger = [touch locationInNode:self];
        
        if (gameOn == false) {
            
            [hand runAction: [SKAction fadeAlphaTo:0 duration:0.2] completion:^ {
                [hand removeFromParent];
            }];
            
            gameOn = true;
        }
        //moves the player if they touched in the bottom half of the screen
        if (locationOfFinger.y < self.size.height/2) {
            locationOfPlayer = CGPointMake(locationOfFinger.x, locationOfFinger.y +self.size.height/2);
        }
    }
}
*/


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //makes sure the game has began before starting to move everything
    if (gameOn == true) {
        
        scoreDoubleValue = scoreDoubleValue + 0.2;
        score = (int)scoreDoubleValue;
        scoreLabel.text = [NSString stringWithFormat:@"%d",score];
        
        speed = speed + 0.001;
        
        //moves the player towards where ever you tap
        //player.position = locationOfPlayer;
        
        if (locationOfPlayerNow.x >= self.size.width - player.size.width/2){
            locationOfFinger.x = locationOfFingerNow.x;
            locationOfPlayer.x = self.size.width - player.size.width/2;
            //have to do this or else the y value can move even though the previous if stament has told the not to
            if (moveThePlayerY == true) {
                player.position = CGPointMake(locationOfPlayer.x, locationOfPlayerNow.y);
            }
            moveThePlayerX = false;
        
        } else if (locationOfPlayerNow.x <= player.size.width/2) {
            locationOfFinger.x = locationOfFingerNow.x;
            locationOfPlayer.x = player.size.width/2;
            //have to do this or else the y value can move even though the previous if stament has told the not to
            if (moveThePlayerY == true) {
                player.position = CGPointMake(locationOfPlayer.x, locationOfPlayerNow.y);
            }
            moveThePlayerX = false;
            
        } else {
            moveThePlayerX = true;
        }
        
        if (locationOfPlayerNow.y <= self.size.height/2 +  player.size.height/2) {
           locationOfFinger.y = locationOfFingerNow.y;
            locationOfPlayer.y = self.size.height/2 +  player.size.height/2;
            //have to do this or else the x value can move even though the previous if stament has told the not to
            if (moveThePlayerX == true) {
                player.position = CGPointMake(locationOfPlayerNow.x, locationOfPlayer.y);
            }
            moveThePlayerY = false;

       
        } else if (locationOfPlayerNow.y >= self.size.height - player.size.height/2) {
           locationOfFinger.y = locationOfFingerNow.y;
            locationOfPlayer.y = self.size.height - player.size.height/2;
            //have to do this or else the x value can move even though the previous if stament has told the not to
            if (moveThePlayerX == true) {
                player.position = CGPointMake(locationOfPlayerNow.x, locationOfPlayer.y);
            }
            moveThePlayerY = false;
        } else {
            moveThePlayerY = true;
        }
        
        //this only happens wehn the [player isnt touching any walls otherwise one of the other if staments (^^^) will run and only move either the x or y value of the player
        if ((moveThePlayerX == true) && (moveThePlayerY == true)) {
                player.position = locationOfPlayerNow;
            }
        
        
    
        //move the first block (block1)
        //moves it left and right
        if (block1Left == true) {
            block1.position = CGPointMake(block1.position.x - speed, block1.position.y);
        } else {
            block1.position = CGPointMake(block1.position.x + speed, block1.position.y);
        }
        //moves it up and down
        if (block1Up == true) {
            block1.position = CGPointMake(block1.position.x, block1.position.y + speed);
        } else {
            block1.position = CGPointMake(block1.position.x, block1.position.y - speed);
        }
        //
        
        //moves the second block (block2)
        //moves it left and right
        if (block2Left == true) {
            block2.position = CGPointMake(block2.position.x - speed, block2.position.y);
        } else {
            block2.position = CGPointMake(block2.position.x + speed, block2.position.y);
        }
        //moves it up and down
        if (block2Up == true) {
            block2.position = CGPointMake(block2.position.x, block2.position.y + speed);
        } else {
            block2.position = CGPointMake(block2.position.x, block2.position.y - speed);
        }
        //
        
        //moves the third block (block3)
        //moves it left and right
        if (block3Left == true) {
            block3.position = CGPointMake(block3.position.x - speed, block3.position.y);
        } else {
            block3.position = CGPointMake(block3.position.x + speed, block3.position.y);
        }
        //moves it up and down
        if (block3Up == true) {
            block3.position = CGPointMake(block3.position.x, block3.position.y + speed);
        } else {
            block3.position = CGPointMake(block3.position.x, block3.position.y - speed);
        }
        //

        //moves the fourth block (block4)
        //moves it left and right
        if (block4Left == true) {
            block4.position = CGPointMake(block4.position.x - speed, block4.position.y);
        } else {
            block4.position = CGPointMake(block4.position.x + speed, block4.position.y);
        }
        //moves it up and down
        if (block4Up == true) {
            block4.position = CGPointMake(block4.position.x, block4.position.y + speed);
        } else {
            block4.position = CGPointMake(block4.position.x, block4.position.y - speed);
        }
        //

    }
    
    
    //makes the blocks change direction if the hit the walls
    
    //block1
    if (block1.position.x + block1.frame.size.width/2 > self.size.width) {
        block1Left = true;
    }
    if (block1.position.x - block1.frame.size.width/2 < 0) {
        block1Left = false;
    }
    if (block1.position.y + block1.frame.size.height/2 > self.size.height) {
        block1Up = false;
    }
    if (block1.position.y - block1.frame.size.height/2 < self.size.height/2) {
        block1Up = true;
    }
    
    //block2
    if (block2.position.x + block2.frame.size.width/2 > self.size.width) {
        block2Left = true;
    }
    if (block2.position.x - block2.frame.size.width/2 < 0) {
        block2Left = false;
    }
    if (block2.position.y + block2.frame.size.height/2 > self.size.height) {
        block2Up = false;
    }
    if (block2.position.y - block2.frame.size.height/2 < self.size.height/2) {
        block2Up = true;
    }
    
    //block3
    if (block3.position.x + block3.frame.size.width/2 > self.size.width) {
        block3Left = true;
    }
    if (block3.position.x - block3.frame.size.width/2 < 0) {
        block3Left = false;
    }
    if (block3.position.y + block3.frame.size.height/2 > self.size.height) {
        block3Up = false;
    }
    if (block3.position.y - block3.frame.size.height/2 < self.size.height/2) {
        block3Up = true;
    }
    
    //block4
    if (block4.position.x + block4.frame.size.width/2 > self.size.width) {
        block4Left = true;
    }
    if (block4.position.x - block4.frame.size.width/2 < 0) {
        block4Left = false;
    }
    if (block4.position.y + block4.frame.size.height/2 > self.size.height) {
        block4Up = false;
    }
    if (block4.position.y - block4.frame.size.height/2 < self.size.height/2) {
        block4Up = true;
    }
    
    
    //makes the player die if they used the glitch to get heaps of points
    if ((player.position.y > self.size.height + player.size.width/2) || (player.position.y < self.size.height/2 - player.size.width/2) || (player.position.x > self.size.width + player.size.width/2) || (player.position.y < - player.size.width/2)) {
        
        //teleport the player to the block ones position so they will definetely die
        player.position = block1.position;
        
    }
    
    
}


- (void) youDied {
    
    //you died
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMusic" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayMenuMusic" object:nil];
    
    //save current score
    [defaults setInteger:score forKey:@"currentScore"];
    
    //save highscore
    if (score > [defaults integerForKey:@"highScore"]){
        [defaults setInteger:score forKey:@"highScore"];
        
    }
    
    //gamecenter stuff
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"Highscore"];
    scoreReporter.value = [defaults integerForKey:@"highScore"];
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil){
            NSLog(@"Submitting score failed");
        } else {
            NSLog(@"Submitting score succeeded");
        }
    }];
    
    //save whether to show the tutorial
    [defaults setBool:dontShowTutorial forKey:@"dontShowTutorial"];
    
    //save amount of coins
    gemTotal = gemCount + (int)[defaults integerForKey:@"gemAmount"];
    [defaults setInteger:gemTotal forKey:@"gemAmount"];
    
    [defaults setBool:true forKey:@"PlayDyingSound"];
    [defaults synchronize];
    
    gameOn = false;
    
    SKScene *gameOverScreen  = [[GameOverScreen alloc] initWithSize:self.size];
    SKTransition *appear = [SKTransition fadeWithDuration:0.7];
    [self.view presentScene:gameOverScreen transition:appear];
    
    
}

@end
