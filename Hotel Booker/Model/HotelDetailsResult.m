//
//  HotelDetailsResult.m
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelDetailsResult.h"

@implementation HotelDetailsResult

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelDetailsResult class]];
		[mapping addAttributeMappingsFromArray:@[@"bookingTemplate"]];

		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"requestedHotelDetails"
																				toKeyPath:@"hotelDetails"
																			  withMapping:HotelDetails.rkMapping]];
	}
	return mapping;
}

@end
