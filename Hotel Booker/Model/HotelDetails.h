//
//  HotelDetails.h
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "HotelDetailItem.h"
#import "HotelRateDetail.h"
#import "HotelProperty.h"

@interface HotelDetails : NSObject

@property (nonatomic) NSArray /* HotelDetailItem */ *hotelDetailItems;
@property (nonatomic) NSArray /* HotelRateDetail */ *hotelRateDetails;
@property (nonatomic) HotelProperty *hotelProperty;

@property (nonatomic, readonly) NSString *checkInTime;
@property (nonatomic, readonly) NSString *checkOutTime;

- (NSString *)hotelDetailValueWithName:(NSString *)name;

+ (RKObjectMapping *)rkMapping;

@end
