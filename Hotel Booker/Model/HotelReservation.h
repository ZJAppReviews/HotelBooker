//
//  HotelReservation.h
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelReservation : NSObject

@property (nonatomic) NSString *bookingConfirmation;
@property (nonatomic) NSString *providerReservationInfoRef;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
