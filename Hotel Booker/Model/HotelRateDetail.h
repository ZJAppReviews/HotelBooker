//
//  HotelRateDetail.h
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "RoomRateDescription.h"
#import "HotelRateByDate.h"
#import "GuaranteeInfo.h"

@interface HotelRateDetail : NSObject

@property (nonatomic) NSArray /* RoomRateDescription */ *roomRateDescriptions;
@property (nonatomic) NSArray /* HotelRateByDate */ *hotelRatesByDate;
@property (nonatomic) NSString *ratePlanType;
@property (nonatomic) NSString *rateCategory;
@property (nonatomic) NSString *totalString;
@property (nonatomic, readonly) CurrencyAmount *total;
@property (nonatomic) NSString *taxString;
@property (nonatomic, readonly) CurrencyAmount *tax;
@property (nonatomic) NSString *baseString;
@property (nonatomic, readonly) CurrencyAmount *baseAmount;
@property (nonatomic) GuaranteeInfo *guaranteeInfo;

@property (nonatomic, readonly) NSString *rateDescription;
@property (nonatomic, readonly) CurrencyAmount *indicativeCost;

- (NSString *)roomRateDescriptionValueWithName:(NSString *)name;
- (NSArray /* RoomRateDescription */ *)getFilteredRoomRateDescriptions;
- (HotelRateByDate *)rateForDate:(NSDate *)date;

+ (RKObjectMapping *)rkMapping;

@end
