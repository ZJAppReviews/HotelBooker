//
//  HotelMediaResponse.m
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelMediaResponse.h"

@implementation HotelMediaResponse

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelMediaResponse class]];

		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelPropertyWithMediaItems"
																				toKeyPath:@"mediaItemsContainer"
																			  withMapping:MediaItems.rkMapping]];
	}
	return mapping;
}

@end
