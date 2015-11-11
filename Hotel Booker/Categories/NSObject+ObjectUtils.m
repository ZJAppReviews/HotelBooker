//
//  NSObject+ObjectUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 18/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "NSObject+ObjectUtils.h"

@implementation NSObject (ObjectUtils)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(doPerformBlock:) withObject:block afterDelay:delay];
}

- (void)doPerformBlock:(void (^)())block {
	block();
}

@end
