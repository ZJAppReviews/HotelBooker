//
//  HotelBookingResponse.h
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversalRecord.h"

@interface HotelBookingResponse : NSObject

@property (nonatomic) UniversalRecord *universalRecord;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
