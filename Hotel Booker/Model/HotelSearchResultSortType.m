//
//  HotelSearchResultSortType.m
//  Hotel Booker
//
//  Created by Matt Graham on 06/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelSearchResultSortType.h"

@implementation HotelSearchResultSortType

+ (NSArray /* HotelSearchResultSortTypeOption */ *)allTypes {
	NSArray *allTypes = nil;
	if (!allTypes) {
		allTypes = @[
					 [[HotelSearchResultSortType alloc] initWithType:HotelSearchResultSortTypeOptionDistance],
					 [[HotelSearchResultSortType alloc] initWithType:HotelSearchResultSortTypeOptionStarRating],
					 [[HotelSearchResultSortType alloc] initWithType:HotelSearchResultSortTypeOptionPriceLowToHigh],
					 [[HotelSearchResultSortType alloc] initWithType:HotelSearchResultSortTypeOptionPriceHighToLow]
					 ];
	}
	return allTypes;
}

- (instancetype)initWithType:(HotelSearchResultSortTypeOption)type {
	if (self = [super init]) {
		_type = type;
	}
	return self;
}

- (NSComparisonResult)compareHotel:(HotelCompact *)hotel1 withOtherHotel:(HotelCompact *)hotel2 {
	switch (self.type) {
		case HotelSearchResultSortTypeOptionStarRating: {
			double rating1 = hotel1.hotelProperty.hotelRating.rating.doubleValue;
			double rating2 = hotel2.hotelProperty.hotelRating.rating.doubleValue;
			return [self.class compareDouble:rating2 withDouble:rating1];
			break;
		}
		case HotelSearchResultSortTypeOptionPriceLowToHigh: {
			double price1 = hotel1.rateInfo.minimumAmount.amount.doubleValue;
			double price2 = hotel2.rateInfo.minimumAmount.amount.doubleValue;
			return [self.class compareDouble:price1 withDouble:price2];
			break;
		}
		case HotelSearchResultSortTypeOptionPriceHighToLow: {
			double price1 = hotel1.rateInfo.minimumAmount.amount.doubleValue;
			double price2 = hotel2.rateInfo.minimumAmount.amount.doubleValue;
			return [self.class compareDouble:price2 withDouble:price1];
			break;
		}
		case HotelSearchResultSortTypeOptionDistance:
		default: {
			double distance1 = hotel1.hotelProperty.distance.value;
			double distance2 = hotel2.hotelProperty.distance.value;
			return [self.class compareDouble:distance1 withDouble:distance2];
			break;
		}
	}
}

- (NSString *)description {
	switch (self.type) {
		case HotelSearchResultSortTypeOptionStarRating:
			return NSLocalizedString(@"Star rating", @"");
			break;
		case HotelSearchResultSortTypeOptionPriceLowToHigh:
			return NSLocalizedString(@"Price (low to high)", @"");
			break;
		case HotelSearchResultSortTypeOptionPriceHighToLow:
			return NSLocalizedString(@"Price (high to low)", @"");
			break;
		case HotelSearchResultSortTypeOptionDistance:
		default:
			return NSLocalizedString(@"Distance", @"");
			break;
	}
	
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		HotelSearchResultSortType *otherSortType = (HotelSearchResultSortType *)other;
		return self.type == otherSortType.type;
	}
}

- (NSUInteger)hash {
	return 628210 + self.type;
}


+ (NSComparisonResult)compareDouble:(double)double1 withDouble:(double)double2 {
	if (double1 < double2) {
		return NSOrderedAscending;
	}
	else if (double1 > double2) {
		return NSOrderedDescending;
	}
	else {
		return NSOrderedSame;
	}
}

@end
