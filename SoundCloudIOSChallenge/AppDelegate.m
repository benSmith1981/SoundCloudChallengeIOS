//
//  AppDelegate.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/23/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "AppDelegate.h"

#import "SCTLikeListViewController.h"

#import "SCTTrackListViewController.h"
@implementation AppDelegate
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    SCTTrackListViewController *viewController1;
    SCTLikeListViewController *viewController2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //Setup the first viewcontroller on the tabbar
        viewController1 = [[SCTTrackListViewController alloc]init];
        viewController1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Incoming Tracks" image:[UIImage imageNamed:@"Sound_WaveIcon.png"] tag:1];
        
        //setup the second view controller on the tab bar
        viewController2 = [[SCTLikeListViewController alloc] init];
        viewController2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Favourites" image:[UIImage imageNamed:@"blackheartIcon.png"] tag:1];

    }
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[viewController1, viewController2];
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)logInstalledFonts
{
    for (NSString *familyName in [UIFont familyNames])
    {
        NSLog(@"Font Family --> %@", familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName])
        {
            NSLog(@"\tFont Name: %@", fontName);
        }
    }
}

+ (void) initialize
{
    [SCSoundCloud setClientID:@"a0d5e34f09e4cdcf7009bb56844b0954"
                       secret:@"773316fe34ecdbb48680e1ea65828ecf"
                  redirectURL:[NSURL URLWithString:@"sampleproject://oauth"]];
     
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
