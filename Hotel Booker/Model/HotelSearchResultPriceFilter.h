//
//  HotelSearchResultPriceFilter.h
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelSearchResultFilter.h"
#import "HotelSearchResult.h"

@interface HotelSearchResultPriceFilter : NSObject <HotelSearchResultFilter>

+ (NSArray /* HotelSearchResultPriceFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult;
+ (NSString *)descriptionForFilters:(NSArray /* HotelSearchResultPriceFilter */ *)filters;

@property (nonatomic) CurrencyAmount *minPrice;
@property (nonatomic) CurrencyAmount *maxPrice;
@property (nonatomic) BOOL maxPriceInclusive;

@end
