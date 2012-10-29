//
//  SoundCloudController.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 27/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "SoundCloudController.h"


@implementation SoundCloudController
@synthesize delegate = _delegate;

-(id)init
{
    return self;
}

- (void) login
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
            [_delegate loginDidFail];
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            [_delegate loginDidFail];
        } else {
            NSLog(@"Done!");
            [_delegate loginSuccess];
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        
        [_delegate loginWithModalView:loginViewController];
    
    }];
}

- (void) logout
{
    [SCSoundCloud removeAccess];
    [_delegate loggedOut];
}

- (void)getTracks {
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
        NSArray *arrayOfCollections;
        
        //check if we get any data back
        if (data != nil) {
            NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                 JSONObjectWithData:data
                                                 options:0
                                                 error:&jsonError];
            NSDictionary *collection = [[NSDictionary alloc]initWithDictionary:(NSDictionary*)jsonResponse];
            arrayOfCollections = [collection objectForKey:@"collection"];
        }
        //if not warn the user problem connecting
        else{
            //delegate call back to failed receive tracks in SCTTrackListViewController
            [_delegate tracksFailedToReceive];
        }
        
        if (!jsonError && [arrayOfCollections isKindOfClass:[NSArray class]]) {
            //delegate call back to tracksReceived in SCTTrackListViewController passing back the data for display
            [_delegate tracksReceived:arrayOfCollections];
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

-(void)getLikes{
    //Check if user logged in or not
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
        NSArray *arrayOfFavourites;
        //check if we get any data back
        if (data != nil) {
            NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                 JSONObjectWithData:data
                                                 options:0
                                                 error:&jsonError];
            arrayOfFavourites = [[NSArray alloc]initWithArray:(NSArray*)jsonResponse];
        }
        //if not warn the user problem connecting
        else{
            //delegate call back to failed receive favorites in SCTLikeListViewController
            [_delegate favoritesFailedToReceive];
        }
        
        if (!jsonError && [arrayOfFavourites isKindOfClass:[NSArray class]]) {
            //delegate call back to favoritesReceived in SCTLikeListViewController passing back the data for display
            [_delegate favoritesReceived:arrayOfFavourites];
        }
    };
    //Get the Favourites
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json"; //I hate the American spelling of favorites!! It's gotta 'U' in it!
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
}

- (void)getUserImage {
    //Check if user logged in or not
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
        NSDictionary *userDetails;
        //check if we get any data back
        if (data != nil) {
            NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                 JSONObjectWithData:data
                                                 options:0
                                                 error:&jsonError];
            userDetails = [[NSDictionary alloc]initWithDictionary:(NSDictionary*)jsonResponse];
        }
        //if not warn the user problem connecting
        else{
            //delegate call back to failed receive favorites in SCTLikeListViewController
            [_delegate imageNotReceived];
        }
        
        if (!jsonError && [userDetails isKindOfClass:[NSDictionary class]]) {
            //delegate call back to favoritesReceived in SCTLikeListViewController passing back the data for display
            [_delegate imageReceived:[userDetails objectForKey:@"avatar_url"]];
        }
    };
    //Get the Favourites
    NSString *resourceURL = @"https://api.soundcloud.com/me.json"; //I hate the American spelling of favorites!! It's gotta 'U' in it!
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
}

@end
