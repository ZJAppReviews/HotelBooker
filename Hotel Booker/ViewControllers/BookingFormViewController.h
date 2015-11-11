//
//  BookingFormViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchData.h"
#import "HotelCompact.h"
#import "HotelDetailsResult.h"
#import "HotelRateDetail.h"
#import "LabelledTextField.h"
#import "BookingInfo.h"

@interface BookingFormViewController : BaseViewController

@property (nonatomic) SearchData *searchData;
@property (nonatomic) HotelCompact *hotelCompact;
@property (nonatomic) HotelDetailsResult *hotelDetailsResult;
@property (nonatomic) HotelRateDetail *rateDetail;

@property (weak, nonatomic) IBOutlet LabelledTextField *firstNameField;
@property (weak, nonatomic) IBOutlet LabelledTextField *lastNameField;

@property (weak, nonatomic) IBOutlet LabelledTextField *streetField;
@property (weak, nonatomic) IBOutlet LabelledTextField *cityStateCountyField;
@property (weak, nonatomic) IBOutlet LabelledTextField *countryField;
@property (weak, nonatomic) IBOutlet LabelledTextField *postCodeField;

@property (weak, nonatomic) IBOutlet LabelledTextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet LabelledTextField *emailField;

@property (weak, nonatomic) IBOutlet UIButton *cardTypeButton;
@property (weak, nonatomic) IBOutlet LabelledTextField *cardNumberField;
@property (weak, nonatomic) IBOutlet LabelledTextField *cardExpiryDateField;

- (BookingInfo *)populateBookingInfo;

@end
