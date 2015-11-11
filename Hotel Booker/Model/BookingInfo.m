//
//  BookingInfo.m
//  Hotel Booker
//
//  Created by Matt Graham on 29/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BookingInfo.h"
#import "Config.h"
#import "NSDate+DateFormat.h"
#import "NSString+Validate.h"

static NSString * const targetBranch = @"<targetBranch>";

static NSString * const adults = @"<adults>";
static NSString * const checkIn = @"<in>";
static NSString * const checkOut = @"<out>";
static NSString * const rooms = @"<rooms>";

static NSString * const hotelId = @"<hotelId>";

static NSString * const ratePlanType = @"<ratePlanType>";

static NSString * const firstName = @"<firstName>";
static NSString * const lastName = @"<lastName>";
static NSString * const emailId = @"<emailId>";
static NSString * const phoneNumber = @"<phoneNumber>";
static NSString * const phoneType = @"<phoneType>";
static NSString * const agencyPhoneNumber = @"<agencyPhoneNumber>";
static NSString * const agencyPhoneType = @"<agencyPhoneType>";
static NSString * const guaranteeType = @"<guaranteeType>";
static NSString * const expDate = @"<expDate>";
static NSString * const ccNumber = @"<ccNumber>";
static NSString * const ccType = @"<ccType>";

@implementation BookingInfo

- (NSDate *)expiryDateAsDate {
	return [NSDate parseCreditCardExpiryDateString:self.creditCardExpiryDate];
}

- (BOOL)validate {
	return (self.searchData && self.hoteCompact && self.hotelDetails && self.rateDetail &&
			[self validateFirstName] && [self validateLastName] &&
			[self validateEmailAddress] && [self validatePhoneNumber] &&
			[self validateExpiryDate] && [self validateCreditCardNumber] && self.creditCardType);
}

- (BOOL)validateFirstName {
	return self.firstName && [self.firstName isValidName];
}

- (BOOL)validateLastName {
	return self.lastName && [self.lastName isValidName];
}

- (BOOL)validateEmailAddress {
	return self.emailAddress && [self.emailAddress isValidEmailAddress];;
}

- (BOOL)validatePhoneNumber {
	return self.phoneNumber && [self.phoneNumber isValidPhoneNumber];;
}

- (BOOL)validateExpiryDate {
	return self.creditCardExpiryDate && [self.creditCardExpiryDate isValidCreditCardExpiryDate];
}

- (BOOL)validateCreditCardNumber {
	return self.creditCardNumber && [self.creditCardNumber isValidCreditCardNumber];
}

- (NSString *)completedBookingTemplate:(NSString *)targetBranchValue {
	if (![self validate]) {
		@throw [NSException exceptionWithName:NSInternalInconsistencyException
									   reason:[NSString stringWithFormat:@"You must set all properties to valid values before calling %@", NSStringFromSelector(_cmd)]
									 userInfo:nil];
	}
	
	NSMutableString * result = nil;
	NSError *error = nil;
	NSMutableDictionary *bookingTemplate = [NSMutableDictionary dictionaryWithDictionary:self.hotelDetails.bookingTemplate];
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bookingTemplate options:0 error:&error];
	
	if (error) {
		NSLog(@"jsonStringForBookingTemplate ERROR: %@", error);
	}
	else {
		NSString *bookingTemplateString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		result = [NSMutableString stringWithString:bookingTemplateString];
		
		[result replaceOccurrencesOfString:targetBranch withString:targetBranchValue options:0 range:NSMakeRange(0, result.length)];

		[result replaceOccurrencesOfString:adults withString:@(self.searchData.numAdults).stringValue options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:checkIn withString:self.searchData.checkInDateString options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:checkOut withString:self.searchData.checkOutDateString options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:rooms withString:@"1" options:0 range:NSMakeRange(0, result.length)];
		
		[result replaceOccurrencesOfString:hotelId withString:self.hoteCompact.hotelId options:0 range:NSMakeRange(0, result.length)];
		
		[result replaceOccurrencesOfString:ratePlanType withString:self.rateDetail.ratePlanType options:0 range:NSMakeRange(0, result.length)];
		
		[result replaceOccurrencesOfString:firstName withString:self.firstName options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:lastName withString:self.lastName options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:emailId withString:self.emailAddress options:0 range:NSMakeRange(0, result.length)];
		
		[result replaceOccurrencesOfString:phoneNumber withString:self.phoneNumber options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:phoneType withString:@"Home" options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:agencyPhoneNumber withString:@"1" options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:agencyPhoneType withString:@"Agency" options:0 range:NSMakeRange(0, result.length)];
		NSString *guaranteeTypeString = self.rateDetail.guaranteeInfo.guaranteeTypeString;
		if (!guaranteeTypeString) {
			guaranteeTypeString = GuaranteeInfoStringGuarantee;
		}
		[result replaceOccurrencesOfString:guaranteeType withString:guaranteeTypeString options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:expDate withString:[self.expiryDateAsDate formatApiYearMonth] options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:ccNumber withString:self.creditCardNumber options:0 range:NSMakeRange(0, result.length)];
		[result replaceOccurrencesOfString:ccType withString:self.creditCardType.code options:0 range:NSMakeRange(0, result.length)];
	}
	
	return result;
}

@end
