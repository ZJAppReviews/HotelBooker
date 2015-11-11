//
//  HotelSearchResultFilterSet.m
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelSearchResultFilterSet.h"
#import "HotelSearchResultAmenityFilter.h"
#import "HotelSearchResultDistanceFilter.h"
#import "HotelSearchResultPriceFilter.h"
#import "HotelSearchResultStarRatingFilter.h"

@interface HotelSearchResultFilterSet () {
	NSMutableSet /* HotelSearchResultAmenityFilter */ *_amenityFilters;
	NSMutableSet /* HotelSearchResultDistanceFilter */ *_distanceFilters;
	NSMutableSet /* HotelSearchResultPriceFilter */ *_priceFilters;
	NSMutableSet /* HotelSearchResultStarRatingFilter */ *_starRatingFilters;
}
@end

@implementation HotelSearchResultFilterSet

- (instancetype)init {
	if (self = [super init]){
		[self reset];
	}
	return self;
}

- (void)reset {
	_amenityFilters = [NSMutableSet set];
	_distanceFilters = [NSMutableSet set];
	_priceFilters = [NSMutableSet set];
	_starRatingFilters = [NSMutableSet set];
}

- (void)addFilter:(id<HotelSearchResultFilter>)filter {
	if ([filter isKindOfClass:HotelSearchResultAmenityFilter.class]) {
		[_amenityFilters addObject:filter];
	}
	else if ([filter isKindOfClass:HotelSearchResultDistanceFilter.class]) {
		[_distanceFilters addObject:filter];
	}
	else if ([filter isKindOfClass:HotelSearchResultPriceFilter.class]) {
		[_priceFilters addObject:filter];
	}
	else if ([filter isKindOfClass:HotelSearchResultStarRatingFilter.class]) {
		[_starRatingFilters addObject:filter];
	}
}

- (void)addFiltersFromArray:(NSArray *)filters {
	for (id<HotelSearchResultFilter> filter in filters) {
		[self addFilter:filter];
	}
}

- (void)removeAllObjects {
	[self reset];
}

- (NSArray /* HotelCompact */*)filterHotels:(NSArray /* HotelCompact */*)hotels {
	NSMutableArray *filteredHotels = [NSMutableArray arrayWithArray:hotels];
	
	[self filterHotels:filteredHotels withFilterSet:self.amenityFilters mutuallyExclusive:NO];
	[self filterHotels:filteredHotels withFilterSet:self.distanceFilters mutuallyExclusive:YES];
	[self filterHotels:filteredHotels withFilterSet:self.priceFilters mutuallyExclusive:YES];
	[self filterHotels:filteredHotels withFilterSet:self.starRatingFilters mutuallyExclusive:YES];
	
	return filteredHotels;
}

- (void)filterHotels:(NSMutableArray /* HotelCompact */*)hotels withFilterSet:(NSSet /* id<HotelSearchResultFilter> */*)filters mutuallyExclusive:(BOOL)isMutuallyExclusive {
	
	NSPredicate *predicate = nil;
	if (isMutuallyExclusive) {
		predicate = [NSPredicate predicateWithBlock:
					 ^BOOL(HotelCompact *hotel, NSDictionary *bindings) {
						 return [self filterHotel:hotel withMutuallyExclusiveFilterSet:filters];
					 }];
	}
	else {
		predicate = [NSPredicate predicateWithBlock:
					 ^BOOL(HotelCompact *hotel, NSDictionary *bindings) {
						 return [self filterHotel:hotel withNonMutuallyExclusiveFilterSet:filters];
					 }];
	}
	[hotels filterUsingPredicate:predicate];
}

- (BOOL)filterHotel:(HotelCompact *)hotel withMutuallyExclusiveFilterSet:(NSSet /* id<HotelSearchResultFilter> */*)filters {
	// ensure that with no filters present, there is no effect
	if (filters.count == 0) {
		return YES;
	}
	
	// with a mutually-exclusive filter set, such as Amenities, the hotel must satisfy one of the filters.
	for (id<HotelSearchResultFilter> filter in filters) {
		if ([filter hotelPassesTest:hotel]) {
			return YES;
		}
	}
	return NO;
	
}

- (BOOL)filterHotel:(HotelCompact *)hotel withNonMutuallyExclusiveFilterSet:(NSSet /* id<HotelSearchResultFilter> */*)filters {
	// with a non-mutually-exclusive filter set, such as Amenities, the hotel must satisfy all filters.
	for (id<HotelSearchResultFilter> filter in filters) {
		if (![filter hotelPassesTest:hotel]) {
			return NO;
		}
	}
	return YES;
}
@end
