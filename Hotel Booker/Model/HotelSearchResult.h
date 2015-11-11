//
//  HotelSearchResult.h
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "HotelCompact.h"
#import "HotelSearchResultFilterSet.h"
#import "HotelSearchResultSortType.h"

@interface HotelSearchResult : NSObject

@property (nonatomic) NSArray /* HotelCompact */ *hotels;

- (NSArray /* HotelCompact */ *)hotelsFilteredBy:(HotelSearchResultFilterSet *)filterSet andSortedBy:(HotelSearchResultSortType *)sortType;

+ (RKObjectMapping *)rkMapping;

@end
