//
//  NSString+Validate.m
//  Hotel Booker
//
//  Created by Matt Graham on 29/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "NSString+Validate.h"
#import "NSDate+DateFormat.h"
#import "NSDate+DateUtils.h"

@implementation NSString (Validate)

- (BOOL)isValidName {
	return self.length > 0;
}

- (BOOL)isValidEmailAddress {
	static NSString *emailPattern = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
	NSRegularExpression *emailRegEx = [NSRegularExpression regularExpressionWithPattern:emailPattern options:0 error:nil];
	return [emailRegEx numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}
- (BOOL)isValidPhoneNumber {
	return self.length > 0;
}

- (BOOL)isValidCreditCardExpiryDate {
	NSDate *expiryDate = [NSDate parseCreditCardExpiryDateString:self];
	return expiryDate != nil && ![expiryDate isEarlierMonthThan:[NSDate date]];
}

- (BOOL)isValidCreditCardNumber {
	// check that it's only digits
	NSRange range = [self rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet] options:0];
	if (range.location != NSNotFound) {
		return NO;
	}
	
	if (self.length != 16) {
		return NO;
	}
	
	// Perform Luhn validation
	NSUInteger total = 0;
	for (NSInteger i = self.length - 1; i >= 0; --i) {
		NSInteger digit = [NSString stringWithFormat:@"%C", [self characterAtIndex:i]].integerValue;
		NSInteger offset = i - (self.length - 1);
		if (offset % 2 == 0) {
			total += digit;
		}
		else {
			total += digit / 5 + (2 * digit) % 10;
		}
	}
	
	return total % 10 == 0;
}

@end
