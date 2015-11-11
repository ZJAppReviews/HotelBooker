//
//  RateInfo.h
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CurrencyAmount.h"

@interface RateInfo : NSObject

@property (readonly) CurrencyAmount *minimumAmount;
@property NSString *rawMinimumAmount;
@property (readonly) CurrencyAmount *maximumAmount;
@property NSString *rawMaximumAmount;

+ (RKObjectMapping *)rkMapping;

@end
