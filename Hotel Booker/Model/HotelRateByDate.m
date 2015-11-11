//
//  HotelRateByDate.m
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelRateByDate.h"
#import "NSDate+DateFormat.h"

@implementation HotelRateByDate

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelRateByDate class]];
		[mapping addAttributeMappingsFromDictionary:@{
													  @"base" : @"rawBase",
													  @"effectiveDate" : @"effectiveDateString",
													  @"expireDate" : @"expireDateString"
													  }];
	}
	return mapping;
}

- (CurrencyAmount *)baseAmount {
	return [CurrencyAmount amountWithString:self.rawBase];
}

- (NSDate *)effectiveDate {
	return [NSDate parseApiDateString:self.effectiveDateString];
}

- (NSDate *)expireDate {
	return [NSDate parseApiDateString:self.expireDateString];
}

- (BOOL)isValidForDate:(NSDate *)date {
	NSDate *effectiveDate = self.effectiveDate;
	NSDate *expireDate = self.expireDate;
	if (!effectiveDate || !expireDate) {
		return NO;
	}

	// date can include the effective date, and be up to but not including the expiry date
	return [date compare:effectiveDate] != NSOrderedAscending && [date compare:expireDate] == NSOrderedAscending;
}


@end
