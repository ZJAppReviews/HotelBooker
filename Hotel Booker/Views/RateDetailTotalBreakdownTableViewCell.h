//
//  RateDetailTotalBreakdownTableViewCell.h
//  Hotel Booker
//
//  Created by Matt Graham on 23/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchData.h"
#import "HotelRateDetail.h"

@class RateDetailTotalBreakdownTableViewCell;

@protocol RateDetailTotalBreakdownTableViewCellDelegate <NSObject>

- (void) cell:(RateDetailTotalBreakdownTableViewCell*)cell breakdownExpanded:(BOOL)expanded;

@end

@interface RateDetailTotalBreakdownTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *breakdownContainer;

@property (nonatomic, weak) id<RateDetailTotalBreakdownTableViewCellDelegate> delegate;
@property (nonatomic) SearchData *searchData;
@property (nonatomic) HotelRateDetail *rateDetail;

// Must be called by viewcontroller for proper rotation handling
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
								duration:(NSTimeInterval)duration;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;


- (CGFloat)breakdownHeight;

@end
