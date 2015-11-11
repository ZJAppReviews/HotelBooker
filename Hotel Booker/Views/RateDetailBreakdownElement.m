//
//  RateDetailBreakdownElement.m
//  Hotel Booker
//
//  Created by Matt Graham on 24/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RateDetailBreakdownElement.h"
#import "UIView+ViewUtils.h"
#import "NSDate+DateFormat.h"

@interface RateDetailBreakdownElement ()

@property (nonatomic, strong) UIView *nibView;

@end

@implementation RateDetailBreakdownElement

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[self setUp:YES];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		[self setUp:NO];
	}
	return self;
}

- (void) setUp:(BOOL)fromCoder {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSArray *nibContents = [bundle loadNibNamed:@"RateDetailBreakdownElement" owner:self options:nil];
	self.nibView = nibContents[0];
	self.nibView.backgroundColor = [UIColor clearColor];
	
	if(fromCoder) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	[self addSubview:self.nibView];
	
	[self matchAutoLayoutConstraintsWithChild:self.nibView];
}

- (void)setDate:(NSDate *)date andRate:(HotelRateByDate *)rate {
	self.dayLabel.text = [date formatShortDayOfWeek];
	self.amountLabel.text = rate ? rate.baseAmount.formattedCurrencyNoDecimal : NSLocalizedString(@"???", @"Unknown rate for date in rate breakdown");
}

@end
