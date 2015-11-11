//
//  HotelDetailItem.m
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelDetailItem.h"

@implementation HotelDetailItem

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelDetailItem class]];
		[mapping addAttributeMappingsFromArray:@[
												 @"name",
												 @"text"
												 ]];
	}
	return mapping;
}

@end
