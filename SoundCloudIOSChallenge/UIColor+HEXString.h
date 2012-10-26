//
//  UIColor+HEXString.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/25/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (HEXString)

+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

@end
