//
//  HotelCompact.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelCompact.h"
#import	<RestKit/RestKit.h>

@implementation HotelCompact

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelCompact class]];
		
		[self populateMapping:mapping];
	}
	return mapping;
}

+ (void)populateMapping:(RKObjectMapping *)mapping {
	[mapping addAttributeMappingsFromArray:@[@"hotelId"]];
	
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelProperty"
																			toKeyPath:@"hotelProperty"
																		  withMapping:HotelProperty.rkMapping]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"mediaItem"
																			toKeyPath:@"mediaItem"
																		  withMapping:MediaItem.rkMapping]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rateInfo"
																			toKeyPath:@"rateInfo"
																		  withMapping:RateInfo.rkMapping]];
}

@end
