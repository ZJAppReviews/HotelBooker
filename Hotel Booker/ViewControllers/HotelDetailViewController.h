//
//  HotelDetailViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "BaseViewController.h"
#import "HotelCompact.h"
#import "HotelDetailsResult.h"
#import "SearchData.h"
#import "StarRating.h"

/**
 * The view controller for the hotel details screen that is accessed when a user selects a particular hotel from the
 * hotel list screen.
 */
@interface HotelDetailViewController : BaseViewController <UIScrollViewDelegate, MKMapViewDelegate>

@property SearchData *searchData;
@property (strong, nonatomic) HotelCompact *hotelCompact;
@property (strong, nonatomic) HotelDetailsResult *hotelDetailsResult;

@property (weak, nonatomic) IBOutlet UIView *indicatorContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIView *scrollViewContents;

@property (weak, nonatomic) IBOutlet UIView *nameContainer;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceContainerTopOffsetConstraint;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet StarRating *starRating;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkOutLabel;

@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAllAmenitiesToggle;

@property (weak, nonatomic) IBOutlet UIView *contactInfoContainer;
@property (weak, nonatomic) IBOutlet UILabel *telephoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *faxNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewTopOffsetConstraint;

@property (weak, nonatomic) IBOutlet UIButton *viewRatesButton;

@end

