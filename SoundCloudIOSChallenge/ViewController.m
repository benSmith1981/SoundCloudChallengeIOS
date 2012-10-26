//
//  ViewController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/23/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "ViewController.h"
#import "SCUI.h"
#import "SCTTrackListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getTracks:(id)sender {
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        NSDictionary *collection = [[NSDictionary alloc]initWithDictionary:(NSDictionary*)jsonResponse];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            SCTTrackListViewController *trackListVC;
            trackListVC = [[SCTTrackListViewController alloc]
                           initWithNibName:@"SCTTrackListViewController"
                           bundle:nil];
            trackListVC.tracks = (NSArray *)jsonResponse;
            [self presentViewController:trackListVC
                               animated:YES completion:nil];
        }
    };
    
    //NSString *resourceURL = @"https://api.soundcloud.com/me/tracks.json";
    NSString *resourceURL = @"https://api.soundcloud.com/me/activities/tracks/affiliated.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
}

- (IBAction)upload:(id)sender
{
    NSURL *trackURL = [NSURL
                       fileURLWithPath:[
                                        [NSBundle mainBundle]pathForResource:@"EvilLaugh" ofType:@"mp3"]];
    
    SCShareViewController *shareViewController;
    SCSharingViewControllerComletionHandler handler;
    
    handler = ^(NSDictionary *trackInfo, NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Uploaded track: %@", trackInfo);
        }
    };
    shareViewController = [SCShareViewController
                           shareViewControllerWithFileURL:trackURL
                           completionHandler:handler];
    [shareViewController setTitle:@"Funny sounds"];
    [shareViewController setPrivate:YES]; 
    [self presentModalViewController:shareViewController animated:YES];
}

- (IBAction) login:(id) sender
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Done!");
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        [self presentModalViewController:loginViewController animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
