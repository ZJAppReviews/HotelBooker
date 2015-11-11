//
//  HotelProperty.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelProperty.h"

@implementation HotelProperty

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelProperty class]];
		[mapping addAttributeMappingsFromArray:@[
												 @"availability",
												 @"name",
												 @"featuredProperty"
												 ]];
		
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"propertyAddress"
																				toKeyPath:@"propertyAddress"
																			  withMapping:PropertyAddress.rkMapping]];
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coordinateLocation"
																				toKeyPath:@"coordinateLocation"
																			  withMapping:GeoLocation.rkMapping]];
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"distance"
																				toKeyPath:@"distance"
																			  withMapping:Distance.rkMapping]];
		
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelRating"
																				toKeyPath:@"hotelRatings"
																			  withMapping:HotelRating.rkMapping]];
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"amenities"
																				toKeyPath:@"amenities"
																			  withMapping:Amenities.rkMapping]];
		
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"phoneNumber"
																				toKeyPath:@"phoneNumbers"
																			  withMapping:PhoneNumber.rkMapping]];

	}
	
	return mapping;
}

- (NSString *)name {
	return _name.capitalizedString;
}

- (HotelRating *)hotelRating {
	if (self.hotelRatings && self.hotelRatings.count > 0) {
		return self.hotelRatings.firstObject;
	}
	else {
		return nil;
	}
}

- (NSString *)telephoneNumber {
	return [self phoneNumberWithType:@"Business"];
}

- (NSString *)faxNumber {
	return [self phoneNumberWithType:@"Fax"];
}

- (NSString *)phoneNumberWithType:(NSString *)type {
	for (PhoneNumber *phoneNumber in self.phoneNumbers) {
		if ([phoneNumber.type isEqualToString:type]) {
			return phoneNumber.number;
		}
	}
	return nil;
}

@end
