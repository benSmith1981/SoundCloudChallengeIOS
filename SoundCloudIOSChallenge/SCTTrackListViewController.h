//
//  SCTTrackListViewController.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 28/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCloudController.h"
#import "SCTTrackListTableView.h"

@interface SCTTrackListViewController : UIViewController <SoundCloudControllerDelegate>
{
    SoundCloudController *soundCloudController;
    SCTTrackListTableView *trackListTable;
 
}
/** Login button displayed on the toolbar, allowing the user to login and out*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;


/**Login action method called when button is pressed
 @param sender The button object
 @return IBAction
 */
- (IBAction)loginButton:(id)sender;

@end
