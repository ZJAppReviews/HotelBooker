//
//  RateDetailTotalBreakdownTableViewCell.m
//  Hotel Booker
//
//  Created by Matt Graham on 23/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RateDetailTotalBreakdownTableViewCell.h"
#import "RateDetailBreakdownElement.h"
#import "NSDate+DateUtils.h"
#import "Palette.h"

#define SEPARATOR_HEIGHT 1.0F
#define SEPARATOR_INSET 10.0F
#define DEFAULT_ANIMATION_DURATION 0.3

@interface RateDetailTotalBreakdownTableViewCell()

@property (nonatomic) BOOL breakdownExpanded;

@end

@implementation RateDetailTotalBreakdownTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setRateDetail:(HotelRateDetail *)rateDetail {
	_rateDetail = rateDetail;
	NSString *totalAmount = rateDetail.total.formattedCurrency;
	self.totalLabel.text = totalAmount ? totalAmount : NSLocalizedString(@"Unknown", @"Unknown Total For Rate Details");
	
	[self updateBreakdownElements:0.2];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
								duration:(NSTimeInterval)duration {
	[self removeBreakdownElements:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self addBreakdownElements:0.2];
}

- (IBAction)breakdownArrowTapped:(UIButton *)sender {
	self.breakdownExpanded = !self.breakdownExpanded;

	CGFloat buttonAngle = 0.0;
	if (self.breakdownExpanded) {
		buttonAngle = M_PI;
	}
	else {
	}
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		sender.transform = CGAffineTransformMakeRotation(buttonAngle);
	} completion:nil];
	
	[self updateBreakdownElements:DEFAULT_ANIMATION_DURATION];
	
	if (self.delegate) {
		[self.delegate cell:self breakdownExpanded:self.breakdownExpanded];
	}
}

- (void)updateBreakdownElements:(NSTimeInterval)animationDuration {
	[self removeBreakdownElements:animationDuration];
	
	[self addBreakdownElements];
}

- (void)removeBreakdownElements:(NSTimeInterval)animationDuration {
	[UIView transitionWithView:self.breakdownContainer
					  duration:animationDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:
	 ^ {
		 for (UIView *view in self.breakdownContainer.subviews) {
			 [view removeFromSuperview];
		 }
	 }
					completion:
	 ^(BOOL finished) {
	 }
	 ];
}

- (void) addBreakdownElements:(NSTimeInterval)animationDuration {
	[UIView transitionWithView:self.breakdownContainer
					  duration:animationDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:
	 ^{
		 [self addBreakdownElements];
	 }
					completion:
	 ^(BOOL finished) {
	 }
	];
}

- (void) addBreakdownElements {
	if (self.breakdownExpanded) {
		NSUInteger elementsPerRow = [self numberOfElementsPerRow];
		CGFloat xPadding = [self xPaddingPerElement];
		CGFloat x = xPadding;
		CGFloat y = 0.0F;
		
		if (self.rateDetail) {
			NSUInteger numDays = [self numberOfElements];
			for (NSUInteger i = 0; i < numDays; ++i) {
				NSDate *elementDate = [self.searchData.checkInDate dateByAddingDays:i];
				HotelRateByDate *rateByDate = [self.rateDetail rateForDate:elementDate];

				RateDetailBreakdownElement *element = [[RateDetailBreakdownElement alloc] initWithFrame:CGRectMake(x, y, RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT, RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT)];
				[element setDate:elementDate andRate:rateByDate];
				[self.breakdownContainer addSubview:element];
				
				if ((i + 1) % elementsPerRow) {
					// move along the x direction
					x += xPadding + RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT;
				}
				else if (i < (numDays - 1)) {
					// add separator and wrap around, if we're not finished
					x = xPadding;
					y = ((i + 1) / elementsPerRow) * RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT;
					CGFloat separatorX = x + SEPARATOR_INSET;
					UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(separatorX, y, [self getWidthAvailable] - (2.0F * separatorX), SEPARATOR_HEIGHT)];
					separator.backgroundColor = TABLE_SEPARATOR_COLOR;
					[self.breakdownContainer addSubview:separator];
					y += SEPARATOR_HEIGHT;
				}
			}
		}
	}
}

- (CGFloat)breakdownHeight {
	CGFloat breakdownHeight = 0.0F;
	if (self.breakdownExpanded && self.rateDetail) {
		NSUInteger elementsPerRow = [self numberOfElementsPerRow];
		NSUInteger numberOfElements = [self numberOfElements];
		NSUInteger rowsRequired = ((numberOfElements - 1) / elementsPerRow) + 1;
		breakdownHeight = rowsRequired * RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT;
		// add room for row separators
		breakdownHeight += (rowsRequired - 1) * SEPARATOR_HEIGHT;
	}
	return breakdownHeight;
}

- (NSUInteger)numberOfElements {
	NSUInteger numberOfElements = 0;
	if (self.searchData) {
		numberOfElements = [self.searchData.checkOutDate daysSince:self.searchData.checkInDate];
	}
	return numberOfElements;
}

- (NSUInteger)numberOfElementsPerRow {
	return [self getWidthAvailable] / RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT;
}

- (CGFloat)xPaddingPerElement {
	NSUInteger elementsPerRow = [self numberOfElementsPerRow];
	return ([self getWidthAvailable] - (elementsPerRow * RATE_DETAIL_BREAKDOWN_ELEMENT_WIDTH_HEIGHT)) / (elementsPerRow + 1);
}

- (CGFloat)getWidthAvailable {
	BOOL isLandscape = UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation);
	CGRect bounds = UIScreen.mainScreen.bounds;
	return isLandscape ? MAX(bounds.size.width, bounds.size.height) : MIN(bounds.size.width, bounds.size.height);
}

@end
