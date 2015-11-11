//
//  HotelSearchResultStarRatingFilter.m
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelSearchResultStarRatingFilter.h"

#define MAX_STARS 5

@implementation HotelSearchResultStarRatingFilter

+ (NSArray /* HotelSearchResultStarRatingFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult {
	NSMutableArray *filters = [NSMutableArray new];
	for (NSUInteger i = 0; i <=  MAX_STARS; ++i) {
		HotelSearchResultStarRatingFilter *filter = [HotelSearchResultStarRatingFilter new];
		filter.numStarsRequired = i;
		[filters addObject:filter];
	}
	
	return filters;
}

+ (NSString *)descriptionForFilters:(NSArray /* HotelSearchResultStarRatingFilter */ *)filters {
	NSMutableArray *ranges = [NSMutableArray new];
	
	NSMutableString *currentRange = [NSMutableString new];
	for (NSUInteger i = 0; i < filters.count; ++i) {
		HotelSearchResultStarRatingFilter *filter = filters[i];
		HotelSearchResultStarRatingFilter *nextFilter = i < filters.count - 1 ? filters[i + 1] : nil;
		if (nextFilter && nextFilter.numStarsRequired == filter.numStarsRequired + 1) {
			if (currentRange.length == 0) {
				[currentRange appendFormat:@"%lu", filter.numStarsRequired];
			}
		}
		else {
			if (currentRange.length == 0) {
				[currentRange appendString:filter.description];
			}
			else {
				[currentRange appendFormat:@" - %@", filter.description];
			}
			[ranges addObject:currentRange];
			currentRange = [NSMutableString new];
		}
	}
	
	return [ranges componentsJoinedByString:@", "];
}

- (BOOL)hotelPassesTest:(HotelCompact *)hotel {
	return hotel.hotelProperty.hotelRating.rating.integerValue == self.numStarsRequired;
}

- (NSString *)description {
	NSString *formatString = self.numStarsRequired == 1 ? NSLocalizedString(@"%lu Star", @"") : NSLocalizedString(@"%lu Stars", @"");
	return [NSString stringWithFormat:formatString, self.numStarsRequired];
}

- (UIImage *)descriptionImage {
	return [UIImage imageNamed:[NSString stringWithFormat:@"%lustars", self.numStarsRequired]];
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		return self.hash == ((HotelSearchResultStarRatingFilter *)other).hash;
	}
}

- (NSUInteger)hash {
	return 4546873 + self.numStarsRequired;
}

@end
