//
//  HotelSearchResultFilter.h
//  Hotel Booker
//
//  Created by Matt Graham on 07/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelCompact.h"

/**
 * A filter for hotel search results
 */
@protocol HotelSearchResultFilter <NSObject>

/** Return YES to include the hotel in the filtered list */
- (BOOL)hotelPassesTest:(HotelCompact *)hotel;

@end