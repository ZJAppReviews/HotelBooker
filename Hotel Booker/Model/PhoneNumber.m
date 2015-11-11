//
//  PhoneNumber.m
//  Hotel Booker
//
//  Created by Matt Graham on 10/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "PhoneNumber.h"

@implementation PhoneNumber

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[PhoneNumber class]];
		[mapping addAttributeMappingsFromArray:@[@"type", @"number"]];
	}
	return mapping;
}

@end
