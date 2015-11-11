//
//  HotelListViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchData.h"
#import "HotelSearchResult.h"

/**
 * The view controller for the hotel list screen that shows the user the results of their search. This is accessed 
 * from the search screen.
 */
@interface HotelListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *indicatorContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (weak, nonatomic) IBOutlet UIView *noResultsContainer;

@property (nonatomic) SearchData *searchData;

@end

