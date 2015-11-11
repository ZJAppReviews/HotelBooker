//
//  HotelSearchResultAmenityFilter.h
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelSearchResultFilter.h"
#import "HotelSearchResult.h"

@interface HotelSearchResultAmenityFilter : NSObject <HotelSearchResultFilter>

+ (NSArray /* HotelSearchResultAmenitiesFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult;

@property (nonatomic) Amenity *amenity;

@end
