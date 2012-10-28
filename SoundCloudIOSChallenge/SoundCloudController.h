//
//  SoundCloudController.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 27/10/2012.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUI.h"
@protocol SoundCloudControllerDelegate;

@interface SoundCloudController : NSObject
{
    __weak id <SoundCloudControllerDelegate> delegate;
}
/** Delegate call back used to pass messages back about logging in and track retrieval */
@property (weak) id <SoundCloudControllerDelegate> delegate;

/**Gets the collection of tracks from the https://api.soundcloud.com/me/activities/tracks/affiliated.json feed
 */
- (void)getTracks;

/**Logs the user in
 */
- (void) login;

/**Logs the user out
 */
- (void) logout;
@end

@protocol SoundCloudControllerDelegate
/**When login fails this delegate call back occurs
 */
- (void)loginDidFail;

/**When login succeeds this delegate call back occurs
 */
- (void)loginSuccess;

/**This is called from the login method so show the modal login view
 @param loginView This is the modal login view passed back to the table view
 */
- (void)loginWithModalView:(SCLoginViewController*)loginView;

/**If we have successfully received tracks then pass back the array of them
 @param arrayOfCollections An array of collection objects from the JSON feed
 */
- (void)tracksReceived:(NSArray*)arrayOfCollections;

/**Called when tracks have not been successfully received for some reason
 */
- (void)tracksFailedToReceive;
@end