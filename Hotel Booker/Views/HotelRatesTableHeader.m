//
//  HotelRatesTableHeader.m
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelRatesTableHeader.h"
#import "NSDate+DateFormat.h"
#import "UIView+ViewUtils.h"

@interface HotelRatesTableHeader()

@property (nonatomic, strong) UIView *nibView;

@end

@implementation HotelRatesTableHeader

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
	NSArray *nibContents = [bundle loadNibNamed:@"HotelRatesTableHeader" owner:self options:nil];
	self.nibView = nibContents[0];
	self.nibView.frame = self.frame;
	self.nibView.backgroundColor = [UIColor clearColor];
	
	if(fromCoder) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	[self addSubview:self.nibView];
	
	[self matchAutoLayoutConstraintsWithChild:self.nibView];
}

- (void)setSearchData:(SearchData *)searchData {
	_searchData = searchData;

	self.numberOfGuestsLabel.text = @(searchData.numAdults).stringValue;
	
	self.checkInDateLabel.text = [searchData.checkInDate formatDayMonth];
	self.checkOutDateLabel.text = [searchData.checkOutDate formatDayMonth];
}

@end
