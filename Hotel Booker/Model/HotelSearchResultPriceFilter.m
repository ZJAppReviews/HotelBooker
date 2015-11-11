//
//  HotelSearchResultPriceFilter.m
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelSearchResultPriceFilter.h"

#define NUM_PRICE_BRACKETS 5

@implementation HotelSearchResultPriceFilter

+ (NSArray /* HotelSearchResultPriceFilter */ *)filtersForSearchResult:(HotelSearchResult *)searchResult {
	CurrencyAmount *minPrice = nil;
	CurrencyAmount *maxPrice = nil;
	
	for (HotelCompact *hotel in searchResult.hotels) {
		CurrencyAmount *price = hotel.rateInfo.minimumAmount;
		if (!minPrice || price.amount.doubleValue < minPrice.amount.doubleValue) {
			minPrice = price;
		}
		if (!maxPrice || price.amount.doubleValue > maxPrice.amount.doubleValue) {
			maxPrice = price;
		}
	}
	
	double priceBracketWidth = (maxPrice.amount.doubleValue - minPrice.amount.doubleValue) / ((double)NUM_PRICE_BRACKETS);
	
	NSMutableArray *filters = [NSMutableArray new];
	for (NSUInteger i = 0; i <  NUM_PRICE_BRACKETS; ++i) {
		HotelSearchResultPriceFilter *filter = [HotelSearchResultPriceFilter new];
		filter.minPrice = [minPrice amountByAddingAmount:(((double)i) * priceBracketWidth)];
		filter.maxPrice = [filter.minPrice amountByAddingAmount:priceBracketWidth];
		// ensure final filter includes most expensive result
		filter.maxPriceInclusive = (i == NUM_PRICE_BRACKETS - 1);
		[filters addObject:filter];
	}
	
	return filters;
}

+ (NSString *)descriptionForFilters:(NSArray /* HotelSearchResultPriceFilter */ *)filters {
	NSMutableArray *ranges = [NSMutableArray new];
	
	NSMutableString *currentRange = [NSMutableString new];
	for (NSUInteger i = 0; i < filters.count; ++i) {
		HotelSearchResultPriceFilter *filter = filters[i];
		if (currentRange.length == 0) {
			[currentRange appendString:filter.minPrice.formattedCurrencyNoDecimal];
		}

		HotelSearchResultPriceFilter *nextFilter = i < filters.count - 1 ? filters[i + 1] : nil;
		if (!nextFilter || nextFilter.minPrice.amount.doubleValue != filter.maxPrice.amount.doubleValue) {
			[currentRange appendFormat:@" - %@", filter.maxPrice.formattedCurrencyNoDecimal];
			[ranges addObject:currentRange];
			currentRange = [NSMutableString new];
		}
	}
	
	return [ranges componentsJoinedByString:@", "];
}

- (BOOL)hotelPassesTest:(HotelCompact *)hotel {
	double price = hotel.rateInfo.minimumAmount.amount.doubleValue;
	
	BOOL aboveMin = self.minPrice.amount.doubleValue <= price;
	// ensure final filter includes most expensive result
	BOOL belowMax = self.maxPriceInclusive ? price <= self.maxPrice.amount.doubleValue : price < self.maxPrice.amount.doubleValue;
	return aboveMin && belowMax;
}

- (NSString *)description {
	return [NSString stringWithFormat:NSLocalizedString(@"%@ - %@", @"price filter description"), self.minPrice.formattedCurrencyNoDecimal, self.maxPrice.formattedCurrencyNoDecimal];
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		return self.hash == ((HotelSearchResultPriceFilter *)other).hash;
	}
}

- (NSUInteger)hash {
	return self.minPrice.amount.doubleValue + self.minPrice.currency.hash + self.maxPrice.amount.doubleValue + self.maxPrice.currency.hash;
}

@end
