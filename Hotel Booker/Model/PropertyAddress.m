//
//  PropertyAddress.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "PropertyAddress.h"

@implementation PropertyAddress

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[PropertyAddress class]];
		[mapping addAttributeMappingsFromArray:@[
												 @"address"
												 ]];
	}
	
	return mapping;
}

@end
