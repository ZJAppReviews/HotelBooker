//
//  BookingViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BaseViewController.h"
#import "HotelRatesTableHeader.h"
#import "SearchData.h"
#import "HotelCompact.h"
#import "HotelDetailsResult.h"
#import "HotelRateDetail.h"

@interface BookingViewController : BaseViewController

@property (nonatomic) SearchData *searchData;
@property (nonatomic) HotelCompact *hotelCompact;
@property (nonatomic) HotelDetailsResult *hotelDetailsResult;
@property (nonatomic) HotelRateDetail *rateDetail;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *rateDescriptionLabel;
@property (weak, nonatomic) IBOutlet HotelRatesTableHeader *ratesTableHeader;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopOffsetConstraint;
@property (weak, nonatomic) IBOutlet UIView *indicatorContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
