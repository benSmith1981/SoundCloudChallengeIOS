//
//  SCTTrackListViewController.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/24/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTTrackListTableView : UITableView 
{
    UIImage *image;
    NSMutableArray *imageInfos;
    NSDictionary *origin;
}

/** Array of tracks received from call to the SoundCloud API */
@property (nonatomic, strong) NSArray *tracks;


/**Launches the app or the website according to the track selected
 @param track This is the JSON data passed to it from the didselect row method that is used to get the URL or track number 
 */
-(void)launchRemoteUrlForTrack:(NSDictionary*)track;


@end
