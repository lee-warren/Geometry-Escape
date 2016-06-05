//
//  GameViewController.m
//  AvoidTheSquares - iOS
//
//  Created by Lee Warren on 3/12/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
@import AVFoundation;


@interface GameViewController () //<ADBannerViewDelegate>



@end

@implementation GameViewController

/* ia stuff
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (banner.isBannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!banner.isBannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
    }
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    //gamecenter stuff
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            NSLog(@"Authentication Successful");
        }
        else
        {
            NSLog(@"Authentication Failed");

        }
    };
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    
        
    //music
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playGameMusic) name:@"PlayGameMusic" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMenuMusic) name:@"PlayMenuMusic" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopAllMusic) name:@"StopAllMusic" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadMusic) name:@"LoadMusic" object:nil];

    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct2) name:@"feature2Purchased" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct3) name:@"feature3Purchased" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unlockProduct4) name:@"feature4Purchased" object:nil];

    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    

    // Create and configure the scene.
    //GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    GameScene *scene = [GameScene sceneWithSize:[skView bounds].size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    [self loadMusic];
    
}



-(void)loadMusic {

    NSURL * menuSongURL = [[NSBundle mainBundle] URLForResource:@"MenuSong" withExtension:@"mp3"];
    _menuSongPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:menuSongURL error:nil];
    _menuSongPlayer.numberOfLoops = -1;
    _menuSongPlayer.volume = 1;
    [_menuSongPlayer prepareToPlay];
    
    
    NSURL * gameSongURL = [[NSBundle mainBundle] URLForResource:@"GameSong" withExtension:@"aif"];
    _gameSongPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:gameSongURL error:nil];
    _gameSongPlayer.numberOfLoops = -1;
    _gameSongPlayer.volume = 1;
    [_gameSongPlayer prepareToPlay];
    
}

-(void)playMenuMusic {
    
    [_gameSongPlayer stop];
    _gameSongPlayer.currentTime = 0;

    [_menuSongPlayer prepareToPlay];
    [_menuSongPlayer play];
    
}

-(void)playGameMusic {
    
    [_menuSongPlayer stop];
    _menuSongPlayer.currentTime = 0;

    [_gameSongPlayer prepareToPlay];
    [_gameSongPlayer play];
    
}

-(void)stopAllMusic {
    
    [_menuSongPlayer stop];
    _menuSongPlayer.currentTime = 0;
    [_gameSongPlayer stop];
    _gameSongPlayer.currentTime = 0;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect bannerRect = CGRectMake(0, self.view.frame.size.height - 50, 320, 50);
    adView = [[ADBannerView alloc] initWithFrame:bannerRect];
    [self.view addSubview:adView];
    
    self.canDisplayBannerAds = NO;
    [adView setHidden:YES];
}

/*
-(void)unlockProduct2 {
    
    NSLog(@"Our class knows that we unlocked Product 2");
    //do whatever you want from unlocking the product
    //BOUGHT 250 GEMS

    gemAmount = (int)[defaults integerForKey:@"gemAmount"];
    gemAmount = gemAmount + 250;

    [defaults setInteger:gemAmount forKey:@"gemAmount"];
    [defaults synchronize];
    
    
}

-(void)unlockProduct3 {
    
    NSLog(@"Our class knows that we unlocked Product 3");
    //do whatever you want from unlocking the product
    //BOUGHT 750 GEMS

    gemAmount = (int)[defaults integerForKey:@"gemAmount"];
    gemAmount = gemAmount + 750;
    
    [defaults setInteger:gemAmount forKey:@"gemAmount"];
    [defaults synchronize];
    
}

-(void)unlockProduct4 {
    
    NSLog(@"Our class knows that we unlocked Product 4");
    //do whatever you want from unlocking the product
    //BOUGHT 200 GEMS
    
    gemAmount = (int)[defaults integerForKey:@"gemAmount"];
    gemAmount = gemAmount + 2000;
    
    [defaults setInteger:gemAmount forKey:@"gemAmount"];
    [defaults synchronize];
    
    
}
*/

// iad stuff
 - (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) {
        self.canDisplayBannerAds = NO;
        [adView setHidden:YES];


    } else if ([notification.name isEqualToString:@"showAd"]) {
        //if ( [[InAppManager sharedManager]isFeature1PurchasedAlready] == YES) {
         //self.canDisplayBannerAds = NO;
         //} else {
         
        self.canDisplayBannerAds = YES;
        [adView setHidden:NO];

    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillLayoutSubviews
{
    /* iad stuff
     self.banner = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.banner.delegate = self;
    [self.banner sizeToFit];
     */
    
   /* if ( [[InAppManager sharedManager]isFeature1PurchasedAlready] == YES) {
        self.canDisplayBannerAds = NO;
    } else {
        self.canDisplayBannerAds = YES;
    }
    */
    
    [super viewWillLayoutSubviews];
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end


// unneeded stuff

/*
 @implementation SKScene (Unarchive)\
 
 
 + (instancetype)unarchiveFromFile:(NSString *)file {
 / Retrieve scene file path from the application bundle /
 NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
 / Unarchive the file to an SKScene object /
 NSData *data = [NSData dataWithContentsOfFile:nodePath
 options:NSDataReadingMappedIfSafe
 error:nil];
 NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
 [arch setClass:self forClassName:@"SKScene"];
 SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
 [arch finishDecoding];
 
 return scene;
 }
 
 
 @end
 */



