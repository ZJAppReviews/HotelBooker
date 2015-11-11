//
//  CalendarViewCell.h
//  Hotel Booker
//
//  Created by Matt Graham on 13/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Represents a single day in the calendar screen table. UpdateView must be called after any changes
 */
@interface CalendarViewCell : UICollectionViewCell

/** The date that this represents */
@property (nonatomic) NSDate *date;

/** The minimum date that is shown in the Calendar */
@property (nonatomic) NSDate *minimumDate;
/** The maximum date that is shown in the Calendar */
@property (nonatomic) NSDate *maximumDate;
/** The start date that is currently selected in the Calendar */
@property (nonatomic) NSDate *selectedCheckInDate;
/** The end date that is currently selected in the Calendar */
@property (nonatomic) NSDate *selectedCheckOutDate;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

- (void)reset;
- (void)updateView;

@end
