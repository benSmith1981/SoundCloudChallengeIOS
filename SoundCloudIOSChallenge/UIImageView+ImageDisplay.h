//
//  UIImage + ImageDisplay.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/25/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (ImageDisplay)

/** This method downloads and displays images from a URL, whilst displaying a placeholder until it has the URL, and does this all on a background thread to free up the UI
 @param placeHolder The placeholder image displayed before the image has been retrieved
 @param imageURL The URL of the image to be downloaded
 */
-(void)displayPlaceHolderImage:(UIImage*)placeHolder FromURLString:(NSString*)imageURL;

@end
