//
//  NSString+Validate.h
//  Hotel Booker
//
//  Created by Matt Graham on 29/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

- (BOOL)isValidName;
- (BOOL)isValidEmailAddress;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidCreditCardExpiryDate;
- (BOOL)isValidCreditCardNumber;

@end
