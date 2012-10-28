//
//  UIColor+HEXString.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/25/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (HEXString)

/**Pass in a hex string, this converts it to hex then ask colourWithHex to conver to a UIColour
 @param str This is the String for the hex
 @return UIColor the colour converted from the hex string
 */
+ (UIColor *)colorWithHexString:(NSString *)str;

/**Takes a hex string for a colour then returns a UIColor back to it's caller
 @param col The string of the colour in hex
 @return UIColor the colour returned converted from hex
 */
+ (UIColor *)colorWithHex:(UInt32)col;

@end
