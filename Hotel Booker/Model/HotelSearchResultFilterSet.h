//
//  HotelSearchResultFilterSet.h
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelSearchResultFilter.h"

@interface HotelSearchResultFilterSet : NSObject

@property (nonatomic, readonly) NSSet /* HotelSearchResultAmenityFilter */ *amenityFilters;
@property (nonatomic, readonly) NSSet /* HotelSearchResultDistanceFilter */ *distanceFilters;
@property (nonatomic, readonly) NSSet /* HotelSearchResultPriceFilter */ *priceFilters;
@property (nonatomic, readonly) NSSet /* HotelSearchResultStarRatingFilter */ *starRatingFilters;

/** This is a set, so the same filter can be given to this function multiple times with no effect */
- (void)addFilter:(id<HotelSearchResultFilter>)filter;
- (void)addFiltersFromArray:(NSArray *)filters;
- (void)removeAllObjects;

- (NSArray /* HotelCompact */*)filterHotels:(NSArray /* HotelCompact */*)hotels;

@end
