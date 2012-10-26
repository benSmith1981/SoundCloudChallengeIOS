//
//  UIImage + ImageDisplay.m
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/25/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import "UIImageView+ImageDisplay.h"

@implementation UIImageView (ImageDisplay)


-(void)displayPlaceHolderImage:(UIImage*)placeHolder FromURLString:(NSString*)imageURL
{
    [self setImage:placeHolder];
    [self setNeedsDisplay];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError *error;
        NSURL *url = [NSURL URLWithString:imageURL];
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
 
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%i \n %@",[error code], [error userInfo]);
//            if ([error code] != 200) {
//                NSLog(@"Download Failed");
//            }
//            else{
                [self setImage:img];
                [self setNeedsDisplay];
//            }
            
        });

    });
}
@end
