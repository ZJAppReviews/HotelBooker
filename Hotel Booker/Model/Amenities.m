//
//  Amenities.m
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "Amenities.h"

@implementation Amenities

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[Amenities class]];
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"amenity"
																				toKeyPath:@"amenity"
																			  withMapping:Amenity.rkMapping]];
	}
	return mapping;
}

@end
