//
//  SCTBaseViewController.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 29/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCloudController.h"

@interface SCTBaseViewController : UIViewController <SoundCloudControllerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    UIImage *image;
    NSMutableArray *imageInfos;
    NSDictionary *origin;
    SoundCloudController *soundCloudController;

}
/** This is the users iamge pulled from facebook shown when they are logged in */
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

/** This is the title of the view */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** This is the UITableView shown with all the tracks in */
@property (nonatomic,strong) IBOutlet UITableView *trackListTable;

/** The reload button to reload the tracks  */
@property (weak, nonatomic) IBOutlet UIToolbar *reload;

/** Array of tracks received from call to the SoundCloud API */
@property (nonatomic, strong) NSArray *tracks;

/** Array of likes received from call to the SoundCloud API */
@property (nonatomic, strong) NSArray *likes;

/** Login button displayed on the toolbar, allowing the user to login and out*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;

/**Launches the app or the website according to the track selected
 @param track This is the JSON data passed to it from the didselect row method that is used to get the URL or track number
 */
-(void)launchRemoteUrlForTrack:(NSDictionary*)track;

/**IBAction method called when the reload button is pressed to reload the tracks in the view
 */
- (IBAction)reload:(id)sender;


/**Login action method called when button is pressed
 @param sender The button object
 @return IBAction
 */
- (IBAction)loginButton:(id)sender;

@end
