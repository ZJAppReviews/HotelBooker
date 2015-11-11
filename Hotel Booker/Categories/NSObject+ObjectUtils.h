//
//  NSObject+ObjectUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 18/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides global utility functions.
 */
@interface NSObject (ObjectUtils)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
