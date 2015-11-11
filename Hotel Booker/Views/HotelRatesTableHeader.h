//
//  HotelRatesTableHeader.h
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchData.h"

IB_DESIGNABLE
@interface HotelRatesTableHeader : UITableViewHeaderFooterView

@property (nonatomic) SearchData *searchData;

@property (weak, nonatomic) IBOutlet UILabel *numberOfGuestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkOutDateLabel;

@end
