//
//  HotelSearchResultAmenityFilter.m
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelSearchResultAmenityFilter.h"

@implementation HotelSearchResultAmenityFilter

+ (NSArray /* HotelSearchResultAmenitiesFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult {
	NSMutableSet *amenityFilterSet = [NSMutableSet new];
	for (HotelCompact *hotel in searchResult.hotels) {
		NSArray *amenities = hotel.hotelProperty.amenities.amenity;
		if (amenities) {
			for (Amenity *amenity in amenities) {
				HotelSearchResultAmenityFilter *filter = [HotelSearchResultAmenityFilter new];
				filter.amenity = amenity;
				[amenityFilterSet addObject:filter];
			}
		}
	}
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"amenity.name"
																   ascending:YES
																	selector:@selector(localizedCaseInsensitiveCompare:)];
	return [amenityFilterSet sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (BOOL)hotelPassesTest:(HotelCompact *)hotel {
	NSArray *amenities = hotel.hotelProperty.amenities.amenity;
	return amenities && [amenities indexOfObject:self.amenity] != NSNotFound;
}

- (NSString *)description {
	return self.amenity.name;
}

- (BOOL)isEqual:(id)other
{
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		HotelSearchResultAmenityFilter *otherAmenityFilter = (HotelSearchResultAmenityFilter *)other;
		return self.hash == otherAmenityFilter.hash;
	}
}

- (NSUInteger)hash
{
	return self.amenity.hash;
}

@end
