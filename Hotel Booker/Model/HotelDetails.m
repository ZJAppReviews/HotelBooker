//
//  HotelDetails.m
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelDetails.h"

@implementation HotelDetails

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelDetails class]];

		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelDetailItem"
																				toKeyPath:@"hotelDetailItems"
																			  withMapping:HotelDetailItem.rkMapping]];


		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelRateDetail"
																				toKeyPath:@"hotelRateDetails"
																			  withMapping:HotelRateDetail.rkMapping]];

		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelProperty"
																				toKeyPath:@"hotelProperty"
																			  withMapping:HotelProperty.rkMapping]];
	}
	return mapping;
}

- (NSString *)checkInTime {
	return [self hotelDetailValueWithName:@"CheckInTime"];
}

- (NSString *)checkOutTime {
	return [self hotelDetailValueWithName:@"CheckOutTime"];
}

- (NSString *)hotelDetailValueWithName:(NSString *)name {
	for (HotelDetailItem *detailItem in self.hotelDetailItems) {
		if ([detailItem.name isEqualToString:name]) {
			return detailItem.text;
		}
	}
	return nil;
}

@end
