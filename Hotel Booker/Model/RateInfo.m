//
//  RateInfo.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RateInfo.h"

@implementation RateInfo

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[RateInfo class]];
		[mapping addAttributeMappingsFromDictionary:@{
													  @"minimumAmount" : @"rawMinimumAmount",
													  @"maximumAmount" : @"rawMaximumAmount",
												 }];
	}
	return mapping;
}

- (CurrencyAmount *)minimumAmount {
	return [CurrencyAmount amountWithString:self.rawMinimumAmount];
}

- (CurrencyAmount *)maximumAmount {
	return [CurrencyAmount amountWithString:self.rawMaximumAmount];
}

@end
