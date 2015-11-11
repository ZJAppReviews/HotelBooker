//
//  HotelSearchResultSortType.h
//  Hotel Booker
//
//  Created by Matt Graham on 06/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelCompact.h"

typedef NS_ENUM(NSUInteger, HotelSearchResultSortTypeOption) {
	HotelSearchResultSortTypeOptionDistance,
	HotelSearchResultSortTypeOptionStarRating,
	HotelSearchResultSortTypeOptionPriceLowToHigh,
	HotelSearchResultSortTypeOptionPriceHighToLow
};

@interface HotelSearchResultSortType : NSObject

+ (NSArray /* HotelSearchResultSortTypeOption */ *)allTypes;

@property (nonatomic) HotelSearchResultSortTypeOption type;

- (instancetype)initWithType:(HotelSearchResultSortTypeOption)type;

- (NSComparisonResult)compareHotel:(HotelCompact *)hotel1 withOtherHotel:(HotelCompact *)hotel2;

@end
