//
//  PaddedTextField.m
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "PaddedTextField.h"

@implementation PaddedTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
	CGRect rect = CGRectMake(bounds.origin.x + self.horizontalPadding, bounds.origin.y + self.verticalPadding, bounds.size.width - 2.0F * self.horizontalPadding, bounds.size.height - 2.0 * self.verticalPadding);
	return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	CGRect rect = CGRectMake(bounds.origin.x + self.horizontalPadding, bounds.origin.y + self.verticalPadding, bounds.size.width - 2.0F * self.horizontalPadding, bounds.size.height - 2.0 * self.verticalPadding);
	return rect;
}

@end
