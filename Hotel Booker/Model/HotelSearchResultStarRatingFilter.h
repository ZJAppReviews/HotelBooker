//
//  HotelSearchResultStarRatingFilter.h
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelSearchResultFilter.h"
#import "HotelSearchResult.h"

@interface HotelSearchResultStarRatingFilter : NSObject <HotelSearchResultFilter>

+ (NSArray /* HotelSearchResultStarRatingFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult;
+ (NSString *)descriptionForFilters:(NSArray /* HotelSearchResultStarRatingFilter */ *)filters;

@property (nonatomic) NSUInteger numStarsRequired;

@end
