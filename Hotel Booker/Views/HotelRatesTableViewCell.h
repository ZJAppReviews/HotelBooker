//
//  HotelRatesTableViewCell.h
//  Hotel Booker
//
//  Created by Matt Graham on 11/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelRateDetail.h"

/**
 * Represents a row in the HotelRates Table - update must be called after any changes to the data.
 */
IB_DESIGNABLE
@interface HotelRatesTableViewCell : UITableViewCell

+ (CGFloat)heightForCellWithHotelRateDetail:(HotelRateDetail *)hotelRateDetail andWidth:(CGFloat)width;

/** 0-based index of this rate in the table */
@property (nonatomic) NSUInteger index;
@property (nonatomic) HotelRateDetail *hotelRateDetail;

- (void)update;

@end
