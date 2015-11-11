//
//  RateDetailTableViewCell.h
//  Hotel Booker
//
//  Created by Matt Graham on 22/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomRateDescription.h"

@interface RateDetailTableViewCell : UITableViewCell

+ (CGFloat)heightForCellWithHotelRateDetail:(RoomRateDescription *)roomRateDescription andWidth:(CGFloat)width;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textValueLabel;

/** 0-based index of this rate in the table */
@property (nonatomic) NSUInteger index;
@property (nonatomic) RoomRateDescription *roomRateDescription;

@end
