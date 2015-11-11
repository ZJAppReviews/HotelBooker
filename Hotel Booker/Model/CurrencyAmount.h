//
//  CurrencyAmount.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface CurrencyAmount : NSObject

@property NSString *currency;
@property NSString *amount;
@property (readonly) NSString *currencySymbol;
@property (readonly) NSString *formattedCurrency;
@property (readonly) NSString *formattedCurrencyNoDecimal;

+ (instancetype)amountWithString:(NSString *)string;

- (instancetype)amountByAddingAmount:(double)amount;

+ (RKObjectMapping *)rkMapping;

@end
