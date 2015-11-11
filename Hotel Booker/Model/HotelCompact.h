//
//  HotelCompact.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HotelProperty.h"
#import "MediaItem.h"
#import "RateInfo.h"

@interface HotelCompact : NSObject

@property NSString *hotelId;
@property HotelProperty *hotelProperty;
@property MediaItem *mediaItem;
@property RateInfo *rateInfo;

+ (RKObjectMapping *)rkMapping;
+ (void)populateMapping:(RKObjectMapping *)mapping;

@end
