//
//  HotelSearchResultDistanceFilter.h
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelSearchResultFilter.h"
#import "HotelSearchResult.h"
#import "Distance.h"

@interface HotelSearchResultDistanceFilter : NSObject <HotelSearchResultFilter>

+ (NSArray /* HotelSearchResultDistanceFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult;
+ (NSString *)descriptionForFilters:(NSArray /* HotelSearchResultPriceFilter */ *)filters;

@property (nonatomic) Distance *minDistance;
@property (nonatomic) Distance *maxDistance;

@end
