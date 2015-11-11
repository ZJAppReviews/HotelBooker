//
//  BookingConfirmationViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 30/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BookingConfirmationViewController.h"

@implementation BookingConfirmationViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.emailAddressLabel.text = self.emailAddress;
	self.bookingReferenceLabel.text = self.response.universalRecord.hotelReservation.bookingConfirmation;
	self.locatorCodeLabel.text = self.response.universalRecord.locatorCode;
}

@end
