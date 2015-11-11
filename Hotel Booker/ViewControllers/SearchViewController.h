//
//  SearchViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchBarWithResults.h"
#import "CustomStepper.h"

/**
 * The view controller for the search screen. This is the first screen of the app and allows the user to enter their
 * search criteria and initiate a search.
 */
@interface SearchViewController : BaseViewController <UISearchBarDelegate, SearchBarWithResultsDataSource>

@property (weak, nonatomic) IBOutlet SearchBarWithResults *locationSearchBar;
@property (weak, nonatomic) IBOutlet UIView *currentLocationContainer;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImageView;
@property (weak, nonatomic) IBOutlet UIView *checkInDateContainer;
@property (weak, nonatomic) IBOutlet UILabel *checkInDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkInDateButton;
@property (weak, nonatomic) IBOutlet UIView *checkOutDateContainer;
@property (weak, nonatomic) IBOutlet UILabel *checkOutDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkOutDateButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet CustomStepper *numberOfGuestStepper;

@end
