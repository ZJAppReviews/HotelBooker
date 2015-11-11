//
//  HotelDetailsResult.h
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "HotelDetails.h"

@interface HotelDetailsResult : NSObject

@property (nonatomic) HotelDetails *hotelDetails;
@property (nonatomic) NSDictionary *bookingTemplate;

+ (RKObjectMapping *)rkMapping;

@end
