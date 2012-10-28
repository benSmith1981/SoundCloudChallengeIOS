//
//  SCTTrackListViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/24/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "SCTTrackListTableView.h"
#import "SCUI.h"
#import "SCTCustomCell.h"
#import "UIImageView+ImageDisplay.h"
#import "UIColor+HEXString.h"

@interface SCTTrackListTableView ()

@end

@implementation SCTTrackListTableView
@synthesize tracks = _tracks;



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
    return [_tracks count];
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
