//
//  BookingConfirmationViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 30/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BaseViewController.h"
#import "HotelBookingResponse.h"

@interface BookingConfirmationViewController : BaseViewController

@property (nonatomic) NSString *emailAddress;
@property (nonatomic) HotelBookingResponse *response;

@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookingReferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locatorCodeLabel;

@end
