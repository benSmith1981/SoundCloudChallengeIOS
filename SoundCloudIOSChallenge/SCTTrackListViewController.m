//
//  SCTTrackListViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/24/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "SCTTrackListViewController.h"
#import "SCUI.h"
#import "SCTCustomCell.h"
#import "UIImageView+ImageDisplay.h"
#import "UIColor+HEXString.h"

@interface SCTTrackListViewController ()

@end

@implementation SCTTrackListViewController
@synthesize tracks = _tracks;
@synthesize loginButton = _loginButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (void)viewDidAppear:(BOOL)animated{
    soundCloudController = [[SoundCloudController alloc]init];
    soundCloudController.delegate = self;
    
    SCAccount *account = [SCSoundCloud account];
    //check if the user has already got an open session (previous login)
    if (account == nil) {
        //if not login
        [soundCloudController login];
    }
    else
    {
        //if they have then change button title and get the tracks
        _loginButton.title = @"Logout";
        [soundCloudController getTracks];
    }
    
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SoundCloudControllerDelegate
- (void)loginDidFail{
    _loginButton.title = @"Login";

}
-(void)loginSuccess{
    _loginButton.title = @"Logout";
    [soundCloudController getTracks];
}

- (void)loginWithModalView:(SCLoginViewController*)loginView{
    [self presentModalViewController:loginView animated:YES];
}

- (void)tracksReceived:(NSArray *)arrayOfCollections{
    //populate _tracks with data
    _tracks = [[NSArray alloc]initWithArray:arrayOfCollections];
    //reload table
    [self.tableView reloadData];
}

- (void)tracksFailedToReceive{
    UIAlertView *problemConnecting = [[UIAlertView alloc]
                                      initWithTitle:@"Problem Connecting"
                                      message:@"No data could be retrieved, there could be a problem with your connection, try again later"
                                      delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"OK", nil];
    
    [problemConnecting show];
}

#pragma mark - Login button action

- (IBAction)loginButton:(id)sender {
    //if user is not logged in
    if([_loginButton.title isEqualToString:@"Login"]){
        //then login
        [soundCloudController login];
    }
    else //if user is logged in (so button says logout
    {
        //then log out
        [soundCloudController logout];
        _loginButton.title = @"Login";

        self.tracks = nil;
        [self.tableView reloadData];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SCTCustomCellID = @"SCTCustomCell";
    SCTCustomCell *cell = (SCTCustomCell*)[tableView dequeueReusableCellWithIdentifier:SCTCustomCellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCTCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];

        //cell = [[SCTCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SCTCustomCellID];
        //		cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    
    //get the origin dictionary inside of tracks
    origin = [track objectForKey:@"origin"];
    //Set background colour of waveform to that of SoundClouds, taken from website
    [cell.waveForm setBackgroundColor:[UIColor colorWithHexString:@"#ff6600"]];
    [cell.waveForm displayPlaceHolderImage:[UIImage imageNamed:@"placeHolder.png"] FromURLString:[origin objectForKey:@"waveform_url"]];

    //set colour and text of font to that of SoundClouds, taken from website
    [cell.title setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    cell.title.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.title setText:[origin objectForKey:@"title"]];
    
    cell.creationDate.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.creationDate setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    
    if([origin objectForKey:@"release_year"])//== NULL || [origin objectForKey:@"release_month"] == NULL || [origin objectForKey:@"release_day"] ==NULL)
    {
        cell.creationDate.text = @"No release date specified";
    }
    else
        cell.creationDate.text = [NSString stringWithFormat:@"Year:%@ Month:%@ Day:%@",[origin objectForKey:@"release_year"],[origin objectForKey:@"release_month"],[origin objectForKey:@"release_day"]];
    
    return cell;
}






#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the track that was selected from the table
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    NSLog(@"[track objectForKey:@\"id\"]%@",[track objectForKey:@"id"]);
    
    //get the origin object inside of the tracks
    [self launchRemoteUrlForTrack:[track objectForKey:@"origin"]];
    
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





@end
