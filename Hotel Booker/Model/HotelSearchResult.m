//
//  HotelSearchResult.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelSearchResult.h"

@implementation HotelSearchResult

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelSearchResult class]];
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelSearchResult"
																				toKeyPath:@"hotels"
																			  withMapping:HotelCompact.rkMapping]];
	}
	
	return mapping;
}

- (NSArray /* HotelCompact */ *)hotelsFilteredBy:(HotelSearchResultFilterSet *)filterSet andSortedBy:(HotelSearchResultSortType *)sortType {
	
	NSArray *hotels = self.hotels;
	
	if (filterSet) {
		hotels = [filterSet filterHotels:hotels];
	}

	if (sortType) {
		hotels = [hotels sortedArrayUsingComparator:
			^NSComparisonResult(HotelCompact *hotel1, HotelCompact *hotel2) {
				return [sortType compareHotel:hotel1 withOtherHotel:hotel2];
			}];
	}
	
	return hotels;
}


@end
