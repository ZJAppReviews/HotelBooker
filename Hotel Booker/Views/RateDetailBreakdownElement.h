//
//  RateDetailBreakdownElement.h
//  Hotel Booker
//
//  Created by Matt Graham on 24/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelRateByDate.h"

#define RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT 64.0F

/**
 * A custom control that shows an element of the hotel rate-by-date breakdown
 */
@interface RateDetailBreakdownElement : UIView

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

- (void)setDate:(NSDate *)date andRate: (HotelRateByDate *)rate;

@end
