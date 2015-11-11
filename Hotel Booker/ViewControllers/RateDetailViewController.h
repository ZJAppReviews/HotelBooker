//
//  RateDetailViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 30/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatesBaseViewController.h"
#import "HotelRateDetail.h"

/**
 * The view controller for the rate details screen that is accessed when the user chooses to view a particular rate 
 * from the rates list screen.
 */
@interface RateDetailViewController : RatesBaseViewController

@property (nonatomic) HotelRateDetail *rateDetail;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@end
