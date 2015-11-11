//
//  RateDetailTableViewCell.m
//  Hotel Booker
//
//  Created by Matt Graham on 22/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RateDetailTableViewCell.h"
#import "Palette.h"

#define MAX_CELL_HEIGHT 500.0F

@implementation RateDetailTableViewCell

+ (CGFloat)heightForCellWithHotelRateDetail:(RoomRateDescription *)roomRateDescription andWidth:(CGFloat)width {
	static RateDetailTableViewCell *prototypeCell = nil;
	if (!prototypeCell) {
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		NSArray *nibContents = [bundle loadNibNamed:@"RateDetailTableViewCell" owner:nil options:nil];
		prototypeCell = nibContents[0];
	}
	
	[prototypeCell setNeedsUpdateConstraints];
	[prototypeCell updateConstraintsIfNeeded];
	
	prototypeCell.roomRateDescription = roomRateDescription;
	
	prototypeCell.bounds = CGRectMake(0.0F, 0.0F, width, MAX_CELL_HEIGHT);
	
	[prototypeCell setNeedsLayout];
	[prototypeCell layoutIfNeeded];
	
	// figure out the width available for the multi-line label
	[prototypeCell.contentView systemLayoutSizeFittingSize:prototypeCell.bounds.size];
	CGFloat textWidth = prototypeCell.textValueLabel.bounds.size.width;
	// layout again, with the preferred width set to what it should be
	prototypeCell.textValueLabel.preferredMaxLayoutWidth = textWidth;
	[prototypeCell.contentView systemLayoutSizeFittingSize:prototypeCell.bounds.size];
	
	CGFloat heightOfChildren = 0.0F;
	for (UIView *view in prototypeCell.contentView.subviews) {
		heightOfChildren += view.frame.size.height;
	}
	
	return heightOfChildren;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIndex:(NSUInteger)index {
	_index = index;
	
	if (index % 2) {
		// odd numbered rows are slightly grey
		self.contentView.backgroundColor = ODD_TABLE_ROW_COLOR;
	}
	else {
		self.contentView.backgroundColor = [UIColor clearColor];
	}
}

- (void)setRoomRateDescription:(RoomRateDescription *)roomRateDescription {
	_roomRateDescription = roomRateDescription;
	
	self.nameLabel.text = roomRateDescription.name;
	self.textValueLabel.text = roomRateDescription.text;
}

@end
