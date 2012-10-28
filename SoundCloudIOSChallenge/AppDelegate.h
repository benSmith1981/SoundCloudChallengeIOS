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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) SCTTrackListViewController *trackList;
@end
