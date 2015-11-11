//
//  NSString+StringUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 18/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides NSString-related utility functions.
 */
@interface NSString (StringUtils)

- (BOOL)validateWithPattern:(NSString *)pattern;

@end
