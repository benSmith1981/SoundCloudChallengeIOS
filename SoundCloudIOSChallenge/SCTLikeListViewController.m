//
//  SCTLikeListViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 28/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "SCTLikeListViewController.h"
#import "SCUI.h"
#import "SCTCustomCell.h"
#import "UIImageView+ImageDisplay.h"
#import "UIColor+HEXString.h"

@interface SCTLikeListViewController ()

@end

@implementation SCTLikeListViewController
@synthesize likedTracks = _likedTracks;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        //_loginButton.title = @"Logout";
        [soundCloudController getLikes];
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
    return [_likedTracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SCTCustomCellID = @"SCTCustomCell";
    SCTCustomCell *cell = (SCTCustomCell*)[tableView dequeueReusableCellWithIdentifier:SCTCustomCellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCTCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *favorite = [self.likedTracks objectAtIndex:indexPath.row];
    
    //Set background colour of waveform to that of SoundClouds, taken from website
    [cell.waveForm setBackgroundColor:[UIColor colorWithHexString:@"#ff6600"]];
    [cell.waveForm displayPlaceHolderImage:[UIImage imageNamed:@"placeHolder.png"] FromURLString:[favorite objectForKey:@"waveform_url"]];
    
    //set colour and text of font to that of SoundClouds, taken from website
    [cell.title setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    cell.title.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.title setText:[favorite objectForKey:@"title"]];
    
    cell.creationDate.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.creationDate setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    
    if([favorite objectForKey:@"release_year"] || [favorite objectForKey:@"release_month"] || [favorite objectForKey:@"release_day"])
    {
        cell.creationDate.text = @"No release date specified";
    }
    else
        cell.creationDate.text = [NSString stringWithFormat:@"Year:%@ Month:%@ Day:%@",[favorite objectForKey:@"release_year"],[favorite objectForKey:@"release_month"],[favorite objectForKey:@"release_day"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - SoundCloudControllerDelegate
- (void)loginDidFail{
    //_loginButton.title = @"Login";
    
}
-(void)loginSuccess{
    //_loginButton.title = @"Logout";
    [soundCloudController getTracks];
}

- (void)loginWithModalView:(SCLoginViewController*)loginView{
    [self presentModalViewController:loginView animated:YES];
}

- (void)favoritesReceived:(NSArray *)favorites{
    //populate _tracks with data
    _likedTracks = [[NSArray alloc]initWithArray:favorites];
    //reload table
    [self.tableView reloadData];
}

- (void)favoritesFailedToReceive{
    UIAlertView *problemConnecting = [[UIAlertView alloc]
                                      initWithTitle:@"Problem Connecting"
                                      message:@"No data could be retrieved, there could be a problem with your connection, try again later"
                                      delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"OK", nil];
    
    [problemConnecting show];
}
@end
