//
//  CustomStepper.m
//  Hotel Booker
//
//  Created by Matt Graham on 19/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "CustomStepper.h"
#import "UIView+ViewUtils.h"

@interface CustomStepper()

@property (nonatomic, strong) UIView *nibView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelView;

@end

@implementation CustomStepper

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
	self.minValue = 0;
	self.maxValue = NSUIntegerMax;
	self.label = @"Label";
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSArray *nibContents = [bundle loadNibNamed:@"CustomStepper" owner:self options:nil];
	self.nibView = nibContents[0];
	self.nibView.backgroundColor = [UIColor clearColor];
	
	if(fromCoder) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	self.valueLabelView.text = @(self.value).stringValue;
	
	[self addSubview:self.nibView];
	
	[self matchAutoLayoutConstraintsWithChild:self.nibView];
}

- (void)setLabel:(NSString *)label {
	_label = label;
	self.labelView.text = label;
}

- (void)setValue:(NSUInteger)value {
	if (value >= self.minValue && value <= self.maxValue) {
		_value = value;
		self.valueLabelView.text = @(value).stringValue;
	}
}

- (IBAction)decrementPressed:(id)sender {
	self.value--;
}

- (IBAction)incrementPressed:(id)sender {
	self.value++;
}

@end
