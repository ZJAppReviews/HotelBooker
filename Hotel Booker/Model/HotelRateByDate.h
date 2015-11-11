//
//  HotelRateByDate.h
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CurrencyAmount.h"

@interface HotelRateByDate : NSObject

@property (nonatomic) NSString *rawBase;
@property (nonatomic, readonly) CurrencyAmount *baseAmount;
@property (nonatomic) NSString *effectiveDateString;
@property (nonatomic, readonly) NSDate *effectiveDate;
@property (nonatomic) NSString *expireDateString;
@property (nonatomic, readonly) NSDate *expireDate;

- (BOOL)isValidForDate:(NSDate *)date;

+ (RKObjectMapping *)rkMapping;

@end
