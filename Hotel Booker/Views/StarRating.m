//
//  StarRating.m
//  Hotel Booker
//
//  Created by Matt Graham on 09/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "StarRating.h"
#import "UIView+ViewUtils.h"

@interface StarRating()

@property (nonatomic, strong) UIView *nibView;

@property (nonatomic) UIImage *starSelected;
@property (nonatomic) UIImage *starDeselected;

@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@end

@implementation StarRating

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
	self.starSelected = [UIImage imageNamed:@"ic_star_selected"];
	self.starDeselected = [UIImage imageNamed:@"ic_star_deselected"];

	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSArray *nibContents = [bundle loadNibNamed:@"StarRating" owner:self options:nil];
	self.nibView = nibContents[0];
	self.nibView.backgroundColor = [UIColor clearColor];
	
	if(fromCoder) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	[self addSubview:self.nibView];
	
	[self matchAutoLayoutConstraintsWithChild:self.nibView];
}

- (void)setRating:(NSUInteger)rating {
	if (rating > 5) {
		rating = 0;
	}
	
	_rating = rating;

	self.star1.image = rating >= 1 ? self.starSelected : self.starDeselected;
	self.star2.image = rating >= 2 ? self.starSelected : self.starDeselected;
	self.star3.image = rating >= 3 ? self.starSelected : self.starDeselected;
	self.star4.image = rating >= 4 ? self.starSelected : self.starDeselected;
	self.star5.image = rating >= 5 ? self.starSelected : self.starDeselected;
}

@end
