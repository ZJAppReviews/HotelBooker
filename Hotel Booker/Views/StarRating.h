//
//  StarRating.h
//  Hotel Booker
//
//  Created by Matt Graham on 09/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A Custom star-rating control that show a rating out of 5 stars
 */
IB_DESIGNABLE
@interface StarRating : UIView

/** A rating of between 0 and 5 */
@property (nonatomic) IBInspectable NSUInteger rating;

@end
