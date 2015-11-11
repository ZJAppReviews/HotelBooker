//
//  HotelRating.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelRating.h"

@implementation HotelRating

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelRating class]];
		[mapping addAttributeMappingsFromArray:@[
												 @"rating"
												 ]];
	}
	return mapping;
}

@end
