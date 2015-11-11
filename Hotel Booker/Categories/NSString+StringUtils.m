//
//  NSString+StringUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 18/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "NSString+StringUtils.h"

@implementation NSString (StringUtils)

- (BOOL)validateWithPattern:(NSString *)pattern {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
	NSAssert(regex, @"Unable to create color regex with pattern: %@", pattern);
	NSRange matchRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
	return matchRange.location != NSNotFound;
}

@end
