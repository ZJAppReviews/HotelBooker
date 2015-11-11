//
//  UIColor+ColorUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 18/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Provides UIColor-related utility functions.
 */
@interface UIColor (ColorUtils)

+ (UIColor *)colorWithRGBHexValue:(uint32_t)hexValue;
+ (UIColor *)colorWithRGBAHexValue:(uint32_t)hexValue;

@end
