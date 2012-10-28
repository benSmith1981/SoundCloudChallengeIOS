//
//  SCTTrackListViewController.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/24/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCloudController.h"

@interface SCTTrackListViewController : UITableViewController <SoundCloudControllerDelegate>
{
    UIImage *image;
    NSMutableArray *imageInfos;
    NSDictionary *origin;
    SoundCloudController *soundCloudController;
}
/** Login button displayed on the toolbar, allowing the user to login and out*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;
/** Array of tracks received from call to the SoundCloud API */
@property (nonatomic, strong) NSArray *tracks;

/**Login action method called when button is pressed
 @param sender The button object
 @return IBAction
 */
- (IBAction)loginButton:(id)sender;

/**Launches the app or the website according to the track selected
 @param track This is the JSON data passed to it from the didselect row method that is used to get the URL or track number 
 */
-(void)launchRemoteUrlForTrack:(NSDictionary*)track;

@end
