//
//  SCTLikeListViewController.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 28/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCloudController.h"

@interface SCTLikeListViewController : UITableViewController <SoundCloudControllerDelegate>
{
    SoundCloudController *soundCloudController;
}
/** Array of tracks liked by the user received from call to the SoundCloud API */
@property (nonatomic, strong) NSArray *likedTracks;


@end
