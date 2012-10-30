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


    //check if file has already been stored
    NSString *filePath = [self documentsPathForFileName:[imageURL lastPathComponent]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    //if it doesn't exist download it
    if(!fileExists)
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
                NSData *pngData = UIImagePNGRepresentation(img);
                [pngData writeToFile:filePath atomically:YES];
                [self setImage:img];
                [self setNeedsDisplay];
            });

        });
    }
    //if it does exist then load it from documents directory
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *pngData = [NSData dataWithContentsOfFile:filePath];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:[UIImage imageWithData:pngData]];
                [self setNeedsDisplay];
            });
            
        });

    }
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}
@end
