//
//  CreditCardType.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "CreditCardType.h"

@implementation CreditCardType

+ (NSArray *)allTypes {
	return @[
			 [[CreditCardType alloc] initWithType:CreditCardTypeOptionVisa],
			 [[CreditCardType alloc] initWithType:CreditCardTypeOptionMastercard],
			 [[CreditCardType alloc] initWithType:CreditCardTypeOptionAmericanExpress]
			 ];
}

- (instancetype)initWithType:(CreditCardTypeOption)type {
	if (self = [super init]) {
		_type = type;
	}
	return self;
}

- (NSString *)code {
	switch (self.type) {
		case CreditCardTypeOptionVisa:
			return @"VI";
			break;
		case CreditCardTypeOptionMastercard:
			return @"CA";
			break;
		case CreditCardTypeOptionAmericanExpress:
			return @"AX";
			break;
	}
	
	return nil;
}

- (NSString *)name {
	switch (self.type) {
		case CreditCardTypeOptionVisa:
			return NSLocalizedString(@"Visa", @"");
			break;
		case CreditCardTypeOptionMastercard:
			return NSLocalizedString(@"MasterCard", @"");
			break;
		case CreditCardTypeOptionAmericanExpress:
			return NSLocalizedString(@"American Express", @"");
			break;
	}

	return nil;
}

- (NSString *)description {
	return self.name;
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		CreditCardType *otherCreditCardType = (CreditCardType *)other;
		return self.type == otherCreditCardType.type;
	}
}

- (NSUInteger)hash {
	return 951753 + self.type;
}

@end
