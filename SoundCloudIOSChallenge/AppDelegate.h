//
//  AppDelegate.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/23/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCUI.h>


@class ViewController,SCTTrackListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) SCTTrackListViewController *trackList;
@end
