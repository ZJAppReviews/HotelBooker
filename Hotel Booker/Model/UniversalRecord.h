//
//  UniversalRecord.h
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelReservation.h"

@interface UniversalRecord : NSObject

@property (nonatomic) NSString *locatorCode;
@property (nonatomic) HotelReservation *hotelReservation;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

