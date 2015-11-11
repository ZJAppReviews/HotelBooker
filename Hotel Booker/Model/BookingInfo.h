//
//  BookingInfo.h
//  Hotel Booker
//
//  Created by Matt Graham on 29/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchData.h"
#import "HotelCompact.h"
#import "HotelDetailsResult.h"
#import "HotelRateDetail.h"
#import "CreditCardType.h"

/**
 * Encapsulates all the information required to make a booking
 */
@interface BookingInfo : NSObject

@property (nonatomic) SearchData *searchData;
@property (nonatomic) HotelCompact *hoteCompact;
@property (nonatomic) HotelDetailsResult *hotelDetails;
@property (nonatomic) HotelRateDetail *rateDetail;

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *emailAddress;
@property (nonatomic) NSString *phoneNumber;

@property (nonatomic) NSString *creditCardExpiryDate;
@property (nonatomic) NSString *creditCardNumber;
@property (nonatomic) CreditCardType *creditCardType;

- (BOOL)validate;
- (NSString *)completedBookingTemplate:(NSString *)targetBranch;

@end
