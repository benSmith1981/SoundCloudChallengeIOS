//
//  SCTTrackListViewController.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/24/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SCTTrackListViewController : UITableViewController
{
    UIImage *image;
    NSMutableArray *imageInfos;
    NSDictionary *origin;
}
@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, strong) AVAudioPlayer *player;

@end
