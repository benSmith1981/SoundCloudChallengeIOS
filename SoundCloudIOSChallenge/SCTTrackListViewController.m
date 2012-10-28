//
//  SCTTrackListViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 28/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "SCTTrackListViewController.h"

@interface SCTTrackListViewController ()

@end

@implementation SCTTrackListViewController
@synthesize loginButton = _loginButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    trackListTable = [[SCTTrackListTableView alloc]initWithFrame:CGRectMake(0, 44, 320, 396) style:UITableViewStylePlain];
    [self.view addSubview:trackListTable];
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

//- (void)viewDidUnload {
//    [self setLoginButton:nil];
//    [super viewDidUnload];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
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
        
        trackListTable.tracks = nil;
        [trackListTable reloadData];
        
    }
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
    trackListTable.tracks = [[NSArray alloc]initWithArray:arrayOfCollections];
    //reload table
    [trackListTable reloadData];
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



@end
