//
//  CalendarHeaderView.h
//  Hotel Booker
//
//  Created by Matt Graham on 13/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * The header view shown in between each section of the calendar screen table. This displays the month and year for the 
 * calendar grid in the cells below.
 */
@interface CalendarHeaderView : UICollectionReusableView

/** The date that this represents */
@property (nonatomic) NSDate *date;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end
