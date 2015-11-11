//
//  CurrencyAmount.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "CurrencyAmount.h"
#import <RestKit/RestKit.h>

@implementation CurrencyAmount

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[CurrencyAmount class]];
		[mapping addAttributeMappingsFromDictionary:@{
													  @"cur": @"currency",
													  @"amount": @"amount"
													  }];
	}
	return mapping;
}

+ (instancetype)amountWithString:(NSString *)string {
	CurrencyAmount *amount = nil;
	
	if (string.length > 3) {
		amount = [CurrencyAmount new];
		amount.currency = [string substringToIndex:3];
		amount.amount = [string substringFromIndex:3];
	}
	
	return amount;
}

- (instancetype)amountByAddingAmount:(double)amount {
	CurrencyAmount *amountResult = [CurrencyAmount new];
	amountResult.currency = self.currency;
	amountResult.amount = @(self.amount.doubleValue + amount).stringValue;
	return amountResult;
}

- (NSString *)currencySymbol {
	return [self currencySymbolFromCode:self.currency];
}

- (NSString *)formattedCurrency {
	return [NSString stringWithFormat:@"%@%@", self.currencySymbol, self.amount];
}

- (NSString *)formattedCurrencyNoDecimal {
	NSString *amount = self.amount;
	NSUInteger indexOfDecimal = [amount rangeOfString:@"." options:NSBackwardsSearch].location;
	if (indexOfDecimal != NSNotFound) {
		amount = [amount substringToIndex:indexOfDecimal];
	}
	
	return [NSString stringWithFormat:@"%@%@", self.currencySymbol, amount];
}

- (NSString *)currencySymbolFromCode:(NSString *)currencyCode {
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currencyCode];
	NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
	return currencySymbol;
}

@end
