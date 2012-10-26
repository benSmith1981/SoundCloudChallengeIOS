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
@synthesize tracks;
@synthesize player;

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
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:@"imageupdated" object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//-(void)viewDidUnload{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imageupdated" object:nil];
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //Set background colour of waveform to that of SoundClouds, taken from website
    [cell.waveForm setBackgroundColor:[UIColor colorWithHexString:@"#ff6600"]];
    [cell.waveForm displayPlaceHolderImage:[UIImage imageNamed:@"placeHolder.png"] FromURLString:[track objectForKey:@"waveform_url"]];

    //set colour and text of font to that of SoundClouds, taken from website
    [cell.title setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    cell.title.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.title setText:[track objectForKey:@"title"]];
    
    cell.creationDate.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.creationDate setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    cell.creationDate.text = [NSString stringWithFormat:@"Year:%@ Month:%@ Day:%@",[track objectForKey:@"release_year"],[track objectForKey:@"release_month"],[track objectForKey:@"release_day"]];
    
    return cell;
}


-(void)launchRemoteUrlForTrack:(NSDictionary*)track
{
    NSString *trackID = [NSString stringWithFormat:@"%@",[track objectForKey:@"id"]];
    NSString *permaLink = [track objectForKey:@"permalink_url"];
    
    NSString* params = @"tracks:";
    [params stringByAppendingString:trackID];
    
    NSString* URI = @"soundcloud://"; // Text sent through url.
    
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"[URI stringByAppendingString:trackID] %@",[URI stringByAppendingString:URLEncodedText]);
    NSURL *ourURL = [NSURL URLWithString:[URI stringByAppendingString:URLEncodedText]];
    
    if ([ourApplication canOpenURL:ourURL]) {
        [ourApplication openURL:ourURL];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:permaLink]];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"App Not Found"
//                                                            message:[NSString stringWithFormat:@"%@ is not installed. \nWhould you like to install it?", trackID]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Not now"
//                                                  otherButtonTitles:@"OK", nil];
//        [alertView show];
    }
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
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    NSLog(@"[track objectForKey:@\"id\"]%@",[track objectForKey:@"id"]);
    
    [self launchRemoteUrlForTrack:track];
    
//    NSString *streamURL = [track objectForKey:@"stream_url"];
//    
//    SCAccount *account = [SCSoundCloud account];
//    
//    [SCRequest performMethod:SCRequestMethodGET
//                  onResource:[NSURL URLWithString:streamURL]
//             usingParameters:nil
//                 withAccount:account
//      sendingProgressHandler:nil
//             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                 NSError *playerError;
//                 player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
//                 [player prepareToPlay];
//                 [player play];
//             }];
}

@end
