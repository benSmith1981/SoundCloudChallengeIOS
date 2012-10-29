//
//  SCTTrackListViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 28/10/2012.
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

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//Set title for the view
    [self.titleLabel setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:@"#ff6600"]];
    self.titleLabel.text = @"Incoming Tracks";
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SCTCustomCellID = @"SCTCustomCell";
    SCTCustomCell *cell = (SCTCustomCell*)[tableView dequeueReusableCellWithIdentifier:SCTCustomCellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCTCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    
    //get the origin dictionary inside of tracks
    origin = [track objectForKey:@"origin"];
    //Set background colour of waveform to that of SoundClouds, taken from website
    [cell.waveForm setBackgroundColor:[UIColor colorWithHexString:@"#ff6600"]];
    [cell.waveForm displayPlaceHolderImage:[UIImage imageNamed:@"placeHolder.png"] FromURLString:[origin objectForKey:@"waveform_url"]];
    
    //set colour and text of font to that of SoundClouds, taken from website
    [cell.title setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:13]];
    cell.title.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.title setText:[origin objectForKey:@"title"]];
    
    cell.creationDate.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.creationDate setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:13]];
    
    if([origin objectForKey:@"release_year"] || [origin objectForKey:@"release_month"] || [origin objectForKey:@"release_day"])
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

#pragma mark - SoundCloudControllerDelegate
-(void)loginSuccess{
    self.loginButton.title = @"Logout";
    [soundCloudController getUserImage];
    [soundCloudController getTracks];
}





@end
