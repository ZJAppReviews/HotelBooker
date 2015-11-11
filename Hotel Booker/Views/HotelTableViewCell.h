//
//  HoteTableViewCell.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelCompact.h"
#import "StarRating.h"

/**
 * An individual cell for the hotel list screen.
 */
@interface HotelTableViewCell : UITableViewCell

/** The hotel that this represents */
@property (nonatomic) HotelCompact *hotel;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (nonatomic) UIImage *placeHolderImage;
@property (weak, nonatomic) IBOutlet UIView *imageOverlay;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet StarRating *starRating;

@end
