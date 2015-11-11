//
//  HotelRatesTableViewCell.m
//  Hotel Booker
//
//  Created by Matt Graham on 11/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelRatesTableViewCell.h"
#import "Palette.h"

#define MAX_CELL_HEIGHT 500.0F

@interface HotelRatesTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPaddingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomPaddingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *rateDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation HotelRatesTableViewCell

+ (CGFloat)heightForCellWithHotelRateDetail:(HotelRateDetail *)hotelRateDetail andWidth:(CGFloat)width {
	static HotelRatesTableViewCell *prototypeCell = nil;
	if (!prototypeCell) {
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		NSArray *nibContents = [bundle loadNibNamed:@"HotelRatesTableViewCell" owner:nil options:nil];
		prototypeCell = nibContents[0];
	}
	
	[prototypeCell setNeedsUpdateConstraints];
	[prototypeCell updateConstraintsIfNeeded];

	prototypeCell.hotelRateDetail = hotelRateDetail;
	[prototypeCell update];
	
	prototypeCell.bounds = CGRectMake(0.0F, 0.0F, width, MAX_CELL_HEIGHT);

	[prototypeCell setNeedsLayout];
	[prototypeCell layoutIfNeeded];
	
	// figure out the width available for the multi-line label
	[prototypeCell.contentView systemLayoutSizeFittingSize:prototypeCell.bounds.size];
	CGFloat textWidth = prototypeCell.rateDescriptionLabel.bounds.size.width;
	// layout again, with the preferred width set to what it should be
	prototypeCell.rateDescriptionLabel.preferredMaxLayoutWidth = textWidth;
	[prototypeCell.contentView systemLayoutSizeFittingSize:prototypeCell.bounds.size];
	
	CGFloat heightOfChildren = 0.0F;
	for (UIView *view in prototypeCell.contentView.subviews) {
		heightOfChildren += view.frame.size.height;
	}

	return heightOfChildren;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	
	[self selectBackgroundColor];
}

- (void)update {
	[self selectBackgroundColor];

	self.rateDescriptionLabel.text = self.hotelRateDetail.rateDescription;
	self.priceLabel.text = self.hotelRateDetail.indicativeCost.formattedCurrency;
}

- (void)selectBackgroundColor {
	if (self.isHighlighted) {
		self.contentView.backgroundColor = HIGHLIGHTED_TABLE_ROW_COLOR;
	}
	else {
		if (self.index % 2) {
			// odd numbered rows are slightly grey
			self.contentView.backgroundColor = ODD_TABLE_ROW_COLOR;
		}
		else {
			self.contentView.backgroundColor = [UIColor clearColor];
		}
	}
}

@end
