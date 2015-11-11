//
//  HoteTableViewCell.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelTableViewCell.h"
#import "UIColor+ColorUtils.h"
#import "HotelApi.h"
#import "Config.h"

@implementation HotelTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.textLabel.hidden = true;
	
	self.placeHolderImage = self.thumbnail.image;
	
	[self addGradientOverlayToImage];
	
	[self populate];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	
	[self addGradientOverlayToImage];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self addGradientOverlayToImage];
}

- (void)addGradientOverlayToImage {
	CAGradientLayer *layer = [CAGradientLayer layer];
	layer.frame = self.bounds;
	if (self.isHighlighted) {
		layer.colors = [NSArray arrayWithObjects:
						(id)[[UIColor colorWithWhite:0 alpha:0.85] CGColor],
						(id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
						(id)[[UIColor colorWithWhite:0 alpha:0.85] CGColor],
						nil];
	}
	else {
		layer.colors = [NSArray arrayWithObjects:
						(id)[[UIColor colorWithWhite:0 alpha:0.85] CGColor],
						(id)[[UIColor colorWithWhite:0 alpha:0.0] CGColor],
						(id)[[UIColor colorWithWhite:0 alpha:0.85] CGColor],
						nil];
	}
	
	self.imageOverlay.layer.mask = layer;
}

- (void)setHotel:(HotelCompact *)hotel {
	_hotel = hotel;
	[self populate];
}

- (void)populate {
	if (self.hotel) {
		[self.thumbnail setImage:self.placeHolderImage];
		[[HotelApi sharedInstance] getHotelThumbnail:self.hotel.hotelId forImageView:self.thumbnail];

		self.name.text = self.hotel.hotelProperty.name;
		
		NSString *ratingText = self.hotel.hotelProperty.hotelRating.rating;
		self.starRating.rating = ratingText.integerValue;
		
		self.price.text = nil;
		if (self.hotel.rateInfo.minimumAmount) {
			self.price.text = self.hotel.rateInfo.minimumAmount.formattedCurrency;
		}
		
		self.distance.text = nil;
		if (self.hotel.hotelProperty.distance) {
			self.distance.text = self.hotel.hotelProperty.distance.formattedValue;
		}
	}
}

@end
