//
//  RatesBaseViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 19/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchData.h"
#import "HotelCompact.h"
#import "HotelDetailsResult.h"

/** Common base class for the Rates Table View and Rates Detail View, which share a common stucture, 
 * but different table contents 
 */
@interface RatesBaseViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopOffsetConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) SearchData *searchData;
@property (nonatomic) HotelCompact *hotelCompact;
@property (nonatomic) HotelDetailsResult *hotelDetailsResult;

@end
