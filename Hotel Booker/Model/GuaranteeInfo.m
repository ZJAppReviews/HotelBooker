//
//  GuaranteeInfo.m
//  Hotel Booker
//
//  Created by Matt Graham on 30/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "GuaranteeInfo.h"

NSString * const GuaranteeInfoStringGuarantee = @"Guarantee";
NSString * const GuaranteeInfoStringDeposit = @"Deposit";

@implementation GuaranteeInfo

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[GuaranteeInfo class]];
		[mapping addAttributeMappingsFromDictionary:@{
													  @"guaranteeType" : @"guaranteeTypeString"
													  }];
	}
	return mapping;
}

- (GuaranteeType)guaranteeType {
	if ([self.guaranteeTypeString isEqualToString:GuaranteeInfoStringGuarantee]) {
		return GuaranteeTypeDeposit;
	}
	else {
		return GuaranteeTypeGuarantee;
	}
}

- (NSString *)guaranteeTypeString {
	if (_guaranteeTypeString) {
		return _guaranteeTypeString;
	}
	else {
		return GuaranteeInfoStringGuarantee;
	}
}

@end
