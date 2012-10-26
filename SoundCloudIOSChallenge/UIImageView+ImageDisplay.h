//
//  UIImage + ImageDisplay.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/25/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (ImageDisplay)

-(void)displayPlaceHolderImage:(UIImage*)placeHolder FromURLString:(NSString*)imageURL;

@end
