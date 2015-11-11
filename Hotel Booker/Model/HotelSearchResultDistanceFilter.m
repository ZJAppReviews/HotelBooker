//
//  HotelSearchResultDistanceFilter.m
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelSearchResultDistanceFilter.h"

#define NUM_DISTANCE_BRACKETS 5
#define DISTANCE_BRACKET_WIDTH 5.0

@implementation HotelSearchResultDistanceFilter

+ (NSArray /* HotelSearchResultDistanceFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult {
	NSString *unitsString = nil;
	
	if (searchResult.hotels.count > 0) {
		HotelCompact *hotel = searchResult.hotels.firstObject;
		unitsString = hotel.hotelProperty.distance.unitsString;
	}
	
	NSMutableArray *filters = [NSMutableArray new];
	for (NSUInteger i = 0; i <  NUM_DISTANCE_BRACKETS; ++i) {
		HotelSearchResultDistanceFilter *filter = [HotelSearchResultDistanceFilter new];
		filter.minDistance = [Distance new];
		filter.minDistance.value = DISTANCE_BRACKET_WIDTH * i;
		filter.minDistance.unitsString = unitsString;
		
		// final filter has no maximum bound
		if (i < NUM_DISTANCE_BRACKETS - 1) {
			filter.maxDistance = [Distance new];
			filter.maxDistance.value = filter.minDistance.value + DISTANCE_BRACKET_WIDTH;
			filter.maxDistance.unitsString = unitsString;
		}
		[filters addObject:filter];
	}
	
	return filters;
}

+ (NSString *)descriptionForFilters:(NSArray /* HotelSearchResultPriceFilter */ *)filters {
	NSMutableArray *ranges = [NSMutableArray new];
	
	NSMutableString *currentRange = [NSMutableString new];
	for (NSUInteger i = 0; i < filters.count; ++i) {
		HotelSearchResultDistanceFilter *filter = filters[i];
		if (currentRange.length == 0) {
			[currentRange appendFormat:@"%.0f", filter.minDistance.value];
		}
		
		HotelSearchResultDistanceFilter *nextFilter = i < filters.count - 1 ? filters[i + 1] : nil;
		if (!nextFilter || nextFilter.minDistance.value != filter.maxDistance.value) {
			if (filter.maxDistance) {
				[currentRange appendFormat:@" - %.0f %@", filter.maxDistance.value, filter.maxDistance.formattedUnitsString];
			}
			else {
				[currentRange appendFormat:@" %@+", filter.minDistance.formattedUnitsString];
			}
			[ranges addObject:currentRange];
			currentRange = [NSMutableString new];
		}
	}
	
	return [ranges componentsJoinedByString:@", "];
}

- (BOOL)hotelPassesTest:(HotelCompact *)hotel {
	double distance = hotel.hotelProperty.distance.value;
	
	BOOL aboveMin = self.minDistance.value <= distance;
	// max may not be set, in which, it is unbounded
	BOOL belowMax = self.maxDistance ? distance < self.maxDistance.value : YES;
	return aboveMin && belowMax;
}

- (NSString *)description {
	if (self.maxDistance) {
		return [NSString stringWithFormat:@"%.0f - %.0f %@", self.minDistance.value, self.maxDistance.value, self.maxDistance.formattedUnitsString];
	}
	else {
		return [NSString stringWithFormat:@"%@+", self.minDistance.formattedValue];
	}
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		return self.hash == ((HotelSearchResultDistanceFilter *)other).hash;
	}
}

- (NSUInteger)hash {
	return self.minDistance.value + self.minDistance.unitsString.hash + self.maxDistance.value + self.maxDistance.unitsString.hash;
}

@end
