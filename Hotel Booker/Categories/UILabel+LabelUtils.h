//
//  UILabel+LabelUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 15/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Provides UILabel-related utility functions.
 */
@interface UILabel (LabelUtils)

- (void)setTextAnimated:(NSString *)text;
- (void)setTextColorAnimated:(UIColor *)textColor;

@end
