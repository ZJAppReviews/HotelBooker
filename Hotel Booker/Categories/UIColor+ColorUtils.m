//
//  UIColor+ColorUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 18/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "UIColor+ColorUtils.h"
#import "NSString+StringUtils.h"

@implementation UIColor (ColorUtils)

+ (UIColor *)colorWithRGBHexValue:(uint32_t)hexValue {
	uint8_t red = (hexValue >> 16) & 0xFF;
	uint8_t green = (hexValue >> 8) & 0xFF;
	uint8_t blue = hexValue & 0xFF;
	
	return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+ (UIColor *)colorWithRGBAHexValue:(uint32_t)hexValue {
	uint8_t red = (hexValue >> 24) & 0xFF;
	uint8_t green = (hexValue >> 16) & 0xFF;
	uint8_t blue = (hexValue >> 8) & 0xFF;
	uint8_t alpha = hexValue & 0xFF;
	
	return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

@end
