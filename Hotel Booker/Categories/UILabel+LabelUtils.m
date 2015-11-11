//
//  UILabel+LabelUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 15/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "UILabel+LabelUtils.h"

@implementation UILabel (LabelUtils)

- (void)setTextAnimated:(NSString *)text {
	[UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		self.text = text;
	} completion:^(BOOL finished) {
	}];
}

- (void)setTextColorAnimated:(UIColor *)textColor {
	[UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		self.textColor = textColor;
	} completion:^(BOOL finished) {
	}];
}

@end
