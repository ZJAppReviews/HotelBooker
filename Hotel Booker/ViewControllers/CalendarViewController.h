//
//  CalendarViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 13/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

/**
 * The view controller for the calendar screen. This is accessed form teh search screen and allows the user to select
 * a check-in and check-out date.
 */
@interface CalendarViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** The minimum date that is shown in the Calendar */
@property (nonatomic) NSDate *minimumDate;
/** The maximum date that is shown in the Calendar */
@property (nonatomic) NSDate *maximumDate;

/** The check-in date that is currently selected in the Calendar */
@property (nonatomic) NSDate *selectedCheckInDate;
/** The check-out date that is currently selected in the Calendar */
@property (nonatomic) NSDate *selectedCheckOutDate;
/** Are we currently selecting the check out date? If not, we're selecting the check-in date */
@property (nonatomic) BOOL selectingCheckOutDate;

@property (weak, nonatomic) IBOutlet UILabel *selectedCheckInDateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedCheckInDateLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedCheckInDateContainer;
@property (weak, nonatomic) IBOutlet UILabel *selectedCheckOutDateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedCheckOutDateLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedCheckOutDateContainer;
@property (weak, nonatomic) IBOutlet UILabel *headerMonthLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end
