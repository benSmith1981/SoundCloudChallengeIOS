//
//  SCTTrackListViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/24/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "SCTTrackListViewController.h"
#import "SCUI.h"
#import "ASIHTTPRequest.h"
#import "ImageInfo.h"
#import "SCTCustomCell.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:@"imageupdated" object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imageupdated" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView
//                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    static NSString *STCCustomCellID = @"STCCell";
    SCTCustomCell *cell = (SCTCustomCell *) [tableView dequeueReusableCellWithIdentifier:STCCustomCellID];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:cell];
//    }
    
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"listCell"
                                                     owner:self options:nil];
		cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    ImageInfo *info = [[ImageInfo alloc] initWithSourceURL:[track objectForKey:@"waveform_url"]];
    [imageInfos addObject:info];
    
    cell.title.text = [track objectForKey:@"title"];
    cell.creationDate.text = [NSString stringWithFormat:@"Year:%@ Month:%@ Day:%@",[track objectForKey:@"release_year"],[track objectForKey:@"release_month"],[track objectForKey:@"release_day"]];

    
    return cell;
}

- (void)getImage:(NSURL *)sourceURL  {
    
    NSLog(@"Getting %@...", sourceURL);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sourceURL];
    [request setCompletionBlock:^{
        NSLog(@"Image downloaded.");
        NSData *data = [request responseData];
        image = [[UIImage alloc] initWithData:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageupdated" object:self];

    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error downloading image: %@", error.localizedDescription);
    }];
    [request startAsynchronous];
}


// Add new method
- (void)imageUpdated:(NSNotification *)notif {
    
    ImageInfo *info = [notif object];
    int row = [imageInfos indexOfObject:info];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    NSLog(@"Image for row %d updated!", row);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
    NSString *streamURL = [track objectForKey:@"stream_url"];
    
    SCAccount *account = [SCSoundCloud account];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [player prepareToPlay];
                 [player play];
             }];
}

@end
