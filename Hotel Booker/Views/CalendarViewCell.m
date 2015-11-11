//
//  CalendarViewCell.m
//  Hotel Booker
//
//  Created by Matt Graham on 13/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "CalendarViewCell.h"
#import "Palette.h"
#import "NSDate+DateUtils.h"
#import "NSDate+DateFormat.h"
#import "UIView+ViewUtils.h"

#define BORDER 2.0

#define CHECK_IN_TEXT_COLOR [UIColor whiteColor]
#define CHECK_IN_BG_COLOR TRAVELPORT_BLUE

#define CHECK_OUT_TEXT_COLOR [UIColor whiteColor]
#define CHECK_OUT_BG_COLOR TRAVELPORT_BLUE

#define INTERMEDIATE_TEXT_COLOR [UIColor whiteColor]
#define INTERMEDIATE_BG_COLOR TRAVELPORT_LIGHTBLUE

#define INACTIVE_BG_COLOR [UIColor colorWithRGBHexValue:0xe6e6e6]

#define DEFAULT_TEXT_COLOR TRAVELPORT_BLUE
#define DEFAULT_BG_COLOR [UIColor colorWithRGBHexValue:0xe6e6e6]

@interface CalendarViewCell()

@property CAShapeLayer *leftSpaceLayer;
@property CAShapeLayer *rightSpaceLayer;
@property CAShapeLayer *leftArrowLayer;
@property CAShapeLayer *rightArrowLayer;

@end

@implementation CalendarViewCell

- (void)awakeFromNib{
	[super awakeFromNib];
	// fix issue with "Unable to simultaneously satisfy constraints"
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setDate:(NSDate *)date {
	_date = date;
	
	if (date) {
		self.dayLabel.text = [date formatDayOfMonth];
	}
	else {
		self.dayLabel.text = nil;
	}
}

- (void)reset {
	self.minimumDate = nil;
	self.maximumDate = nil;
	self.selectedCheckInDate = nil;
	self.selectedCheckOutDate = nil;
	self.date = nil;
	if (self.leftSpaceLayer) {
		[self.leftSpaceLayer removeFromSuperlayer];
		self.leftSpaceLayer = nil;
	}
	if (self.rightSpaceLayer) {
		[self.rightSpaceLayer removeFromSuperlayer];
		self.rightSpaceLayer = nil;
	}
	if (self.leftArrowLayer) {
		[self.leftArrowLayer removeFromSuperlayer];
		self.leftArrowLayer = nil;
	}
	if (self.rightArrowLayer) {
		[self.rightArrowLayer removeFromSuperlayer];
		self.rightArrowLayer = nil;
	}
}

- (void)updateView {
	
	UIColor *newTextColor;
	UIColor *newBgColor;
	UIColor *leftSpaceColor = nil;
	UIColor *rightSpaceColor = nil;

	if ([self.date isSameDayAs:self.selectedCheckInDate]) {
		// we are the check in date
		newTextColor = CHECK_IN_TEXT_COLOR;
		rightSpaceColor = newBgColor = CHECK_IN_BG_COLOR;
	}
	else if ([self.date isSameDayAs:self.selectedCheckOutDate]) {
		// we are the check in date
		newTextColor = CHECK_OUT_TEXT_COLOR;
		leftSpaceColor = newBgColor = CHECK_OUT_BG_COLOR;
	}
	else if ([self.date isLaterDayThan:self.selectedCheckInDate] &&
			 [self.date isEarlierDayThan:self.selectedCheckOutDate]){
		// we are not bewteen the check-in and check-out dates
		newTextColor = INTERMEDIATE_TEXT_COLOR;
		newBgColor = INTERMEDIATE_BG_COLOR;
		
		leftSpaceColor = rightSpaceColor = INTERMEDIATE_BG_COLOR;
	}
	else if ([self.date isEarlierDayThan:self.minimumDate] || [self.date isLaterDayThan:self.maximumDate]) {
		// we are not selectable
		newTextColor = INACTIVE_TEXT_COLOR;
		newBgColor = INACTIVE_BG_COLOR;
	}
	else {
		// default
		newTextColor = DEFAULT_TEXT_COLOR;
		newBgColor = DEFAULT_BG_COLOR;
	}
	
	if ([self.date isDayAfter:self.selectedCheckInDate]) {
		// we're the day after check in, so show the right arrow
		leftSpaceColor = CHECK_IN_BG_COLOR;
		[self addArrowBackground:YES];
	}
	if ([self.date isDayBefore:self.selectedCheckOutDate]) {
		// we're the day before check out, so show the left arrow
		rightSpaceColor = CHECK_OUT_BG_COLOR;
		[self addArrowBackground:NO];
	}
	
	//[self setMaskRect:maskRect];
	[self addSpaceColor:NO color:leftSpaceColor];
	[self addSpaceColor:YES color:rightSpaceColor];
	self.dayLabel.textColor = newTextColor;
	self.dayLabel.backgroundColor = newBgColor;
}

- (void)addSpaceColor:(BOOL)isRight color:(UIColor *)color {
	
	if (isRight) {
		if (self.rightSpaceLayer) {
			[self.rightSpaceLayer removeFromSuperlayer];
			self.rightSpaceLayer = nil;
		}
	}
	else {
		if (self.leftSpaceLayer) {
			[self.leftSpaceLayer removeFromSuperlayer];
			self.leftSpaceLayer = nil;
		}
	}
	

	if (color) {
		CAShapeLayer *layer = [CAShapeLayer layer];
		CGRect frame = self.contentView.bounds;
		frame.origin.y = BORDER;
		frame.size.height -= 2.0 * BORDER;
		layer.frame = frame;
		CGFloat startX = isRight ? frame.size.width - BORDER : 0;
		CGPathRef path = CGPathCreateWithRect(CGRectMake(startX, 0, BORDER, frame.size.height), NULL);
		layer.path = path;
		CGPathRelease(path);
		layer.lineWidth = 1.0f;
		layer.fillColor = color.CGColor;
		[self.contentView.layer insertSublayer:layer atIndex:0];
		if (isRight) {
			self.rightSpaceLayer = layer;
		}
		else{
			self.leftSpaceLayer = layer;
		}
	}
}

- (void)addArrowBackground:(BOOL)isRight {
	
	if (isRight) {
		if (self.rightArrowLayer) {
			[self.rightArrowLayer removeFromSuperlayer];
			self.rightArrowLayer = nil;
		}
	}
	else {
		if (self.leftArrowLayer) {
			[self.leftArrowLayer removeFromSuperlayer];
			self.leftArrowLayer = nil;
		}
	}
	
	CAShapeLayer *layer = [CAShapeLayer layer];
	layer.frame = self.dayLabel.bounds;
	
	CGFloat width = layer.frame.size.width;
	CGFloat height = layer.frame.size.height;
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGFloat startX = isRight ? 0.0 : width;
	CGFloat pointOffset = isRight ? width / 6.0 : 5.0 * width / 6.0;
	
	CGPathMoveToPoint(path, nil, startX, 0.0);
	CGPathAddLineToPoint(path, nil, pointOffset, height / 2.0);
	CGPathAddLineToPoint(path, nil, startX, height);
	CGPathAddLineToPoint(path, nil, startX, 0.0);
	CGPathCloseSubpath(path);
	
	layer.path = path;
	CGPathRelease(path);
	layer.lineWidth = 1.0f;
	layer.fillColor = CHECK_IN_BG_COLOR.CGColor;
	[self.dayLabel.layer insertSublayer:layer atIndex:0];
	
	if (isRight) {
		self.rightArrowLayer = layer;
	}
	else{
		self.leftArrowLayer = layer;
	}
}

@end
