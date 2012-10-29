//
//  SCTBaseViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 29/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "SCTBaseViewController.h"
#import "SCTCustomCell.h"
#import "UIImageView+ImageDisplay.h"
#import "UIColor+HEXString.h"

@interface SCTBaseViewController ()

@end

@implementation SCTBaseViewController
@synthesize loginButton = _loginButton;
@synthesize trackListTable = _trackListTable;
@synthesize tracks = _tracks;
@synthesize titleLabel = _titleLabel;
@synthesize likes = _likes;

- (id)init
{
    self = [super initWithNibName:@"SCTBaseViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    soundCloudController = [[SoundCloudController alloc]init];
    soundCloudController.delegate = self;
    
    SCAccount *account = [SCSoundCloud account];
    //check if the user has already got an open session (previous login)
    if (account == nil) {
        //self.userImage = nil;
        self.tracks = nil;
        [self.trackListTable reloadData];
        //if not login
        [soundCloudController login];
    }
    else
    {
        //if they have then change button title and get the tracks
        self.loginButton.title = @"Logout";
        
        //only load the tracks again if there arent any tracks, removes flicker
        if(_tracks == nil)
        {
            [soundCloudController getTracks];
        }
        
        if(_likes == nil)
        {
            [soundCloudController getLikes];
        }
        
        //load user image
        if(_userImage.image == nil)
        {
            [soundCloudController getUserImage];
        }
        
    }
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tracks count];

}


#pragma mark - Login button action

- (IBAction)loginButton:(id)sender {
    //if user is not logged in
    if([self.loginButton.title isEqualToString:@"Login"]){
        //then login
        [soundCloudController login];
    }
    else //if user is logged in (so button says logout
    {
        //then log out
        self.loginButton.title = @"Login";
        //_userImage.hidden = TRUE;

        //_userImage.image = nil;
        //[_userImage setNeedsDisplay];
        _tracks = nil;
        [self.trackListTable reloadData];
        [soundCloudController logout];
    }
}

#pragma mark - Launch app or website

-(void)launchRemoteUrlForTrack:(NSDictionary*)track
{
    //get track id
    NSString *trackID = [NSString stringWithFormat:@"%@",[track objectForKey:@"id"]];
    //get url link
    NSString *permaLink = [track objectForKey:@"permalink_url"];

    NSString* params = @"tracks:";
    //append params with track id
    [params stringByAppendingString:trackID];

    NSString* URI = @"soundcloud://"; // Text sent through url.

    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"[URI stringByAppendingString:trackID] %@",[URI stringByAppendingString:URLEncodedText]);
    //Append URI with URLEncodedText
    NSURL *ourURL = [NSURL URLWithString:[URI stringByAppendingString:URLEncodedText]];

    //if we ahve the Sound cloud app open song with this
    if ([ourApplication canOpenURL:ourURL]) {

        [ourApplication openURL:ourURL];
    }
    //else open the website at the permalink obtained
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:permaLink]];

    }
}

#pragma mark - Reload button action method

- (IBAction)reload:(id)sender {
    [soundCloudController getTracks];
    [self.trackListTable reloadData];

}
#pragma mark - Sound Cloud Controller Delegate methods

/**When login fails this delegate call back occurs
 */

- (void)loginDidFail{
    self.loginButton.title = @"Login";
    
}

/**This is called from the login method so show the modal login view
 @param loginView This is the modal login view passed back to the table view
 */
- (void)loginWithModalView:(SCLoginViewController*)loginView{
    [self presentModalViewController:loginView animated:YES];
}

/**If we have successfully received tracks then pass back the array of them
 @param arrayOfCollections An array of collection objects from the JSON feed
 */
- (void)tracksReceived:(NSArray *)arrayOfCollections{
    //populate _tracks with data
    self.tracks = [[NSArray alloc]initWithArray:arrayOfCollections];
    //reload table
    [self.trackListTable reloadData];
}


/**Called when tracks have not been successfully received for some reason
 */
- (void)tracksFailedToReceive{
    UIAlertView *problemConnecting = [[UIAlertView alloc]
                                      initWithTitle:@"Problem Connecting"
                                      message:@"No tracks could be retrieved, there could be a problem with your connection, try again later"
                                      delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"OK", nil];
    
    [problemConnecting show];
}


/**Called when favorites have been successfully received for some reason
 */
- (void)favoritesReceived:(NSArray *)favorites{
    //populate _tracks with data
    self.likes = [[NSArray alloc]initWithArray:favorites];
    //reload table
    [self.trackListTable reloadData];
}

/**Called when favorites have not been successfully received for some reason
 */
- (void)favoritesFailedToReceive{
    UIAlertView *problemConnecting = [[UIAlertView alloc]
                                      initWithTitle:@"Problem Connecting"
                                      message:@"No 'Likes' could be retrieved, there could be a problem with your connection, try again later"
                                      delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"OK", nil];
    
    [problemConnecting show];
}

/**Called when image for user is received
 */
- (void)imageReceived:(NSString*)userImagePath{
    //if(_userImage == nil)
        [_userImage displayPlaceHolderImage:nil FromURLString:userImagePath];
    //[_userImage setNeedsDisplay];
}

/**Called when image for user is not received
 */
-(void)imageNotReceived{
    NSLog(@"USer image not received");
}

- (void) loggedOut{
    //_userImage.hidden = TRUE;
    _userImage.image = nil;

}


- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setUserImage:nil];
    [self setReload:nil];
    [super viewDidUnload];
}
@end
