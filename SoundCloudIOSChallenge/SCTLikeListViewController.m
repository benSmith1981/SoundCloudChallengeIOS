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

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//Set title for the view
    [self.titleLabel setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:15]];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:@"#ff6600"]];
    self.titleLabel.text = @"Favourites";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.likes count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SCTCustomCellID = @"SCTCustomCell";
    SCTCustomCell *cell = (SCTCustomCell*)[tableView dequeueReusableCellWithIdentifier:SCTCustomCellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCTCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *favorite = [self.likes objectAtIndex:indexPath.row];
    
    //Set background colour of waveform to that of SoundClouds, taken from website
    [cell.waveForm setBackgroundColor:[UIColor colorWithHexString:@"#ff6600"]];
    [cell.waveForm displayPlaceHolderImage:[UIImage imageNamed:@"placeHolder.png"] FromURLString:[favorite objectForKey:@"waveform_url"]];
    
    //set colour and text of font to that of SoundClouds, taken from website
    [cell.title setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:10]];
    cell.title.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.title setText:[favorite objectForKey:@"title"]];
    
    cell.creationDate.textColor = [UIColor colorWithHexString:@"#0066cc"];
    [cell.creationDate setFont:[UIFont fontWithName:@"LucidaGrande-Bold" size:13]];
    
    //if no release date has been specified then show this in the table in a nice form
    if([favorite objectForKey:@"release_year"] || [favorite objectForKey:@"release_month"] || [favorite objectForKey:@"release_day"])
    {
        cell.creationDate.text = @"No release date specified";
    }
    else
        cell.creationDate.text = [NSString stringWithFormat:@"Year:%@ Month:%@ Day:%@",[favorite objectForKey:@"release_year"],[favorite objectForKey:@"release_month"],[favorite objectForKey:@"release_day"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the track that was selected from the table
    NSDictionary *track = [self.likes objectAtIndex:indexPath.row];
    NSLog(@"[track objectForKey:@\"id\"]%@",[track objectForKey:@"id"]);
    
    //get the origin object inside of the tracks
    [self launchRemoteUrlForTrack:track];
}

#pragma mark - SoundCloudControllerDelegate
-(void)loginSuccess{
    self.loginButton.title = @"Logout";
    [soundCloudController getUserImage];
    [soundCloudController getLikes];
}


@end
