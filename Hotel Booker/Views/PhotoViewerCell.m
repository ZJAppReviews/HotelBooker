//
//  PhotoViewerCell.m
//  Hotel Booker
//
//  Created by Matt Graham on 17/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "PhotoViewerCell.h"
#import "UIView+ViewUtils.h"
#import "NSObject+ObjectUtils.h"

@interface PhotoViewerCell()

@end

@implementation PhotoViewerCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if (!CGRectEqualToRect(self.scrollView.frame, self.bounds)) {
		self.scrollView.frame = self.bounds;
		if (self.imageView && !CGRectIsEmpty(self.imageView.frame)) {
			[self setupImageViewWithScrollView];
		}
	}
}

- (void)setMediaItem:(MediaItem *)mediaItem {
	_mediaItem = mediaItem;
	[self update];
}

- (void) update {
	self.placeHolderImageView.hidden = NO;
	
	// starting with a small placeholder image prevents sizing issues on the scrollView, when it is replaced with the final image
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0.0);
	UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if (!self.imageView) {
		self.imageView = [[UIImageView alloc] initWithImage:blankImage];
		self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
		self.imageView.userInteractionEnabled = YES;
		[self.scrollView addSubview:self.imageView];
	}
	else {
		self.imageView.image = blankImage;
	}
	[self setupImageViewWithScrollView];
	
	__weak PhotoViewerCell *weakSelf = self;
	[self.mediaItem getImageForImageView:self.imageView success:
	 ^(UIImage *image) {
		 if (weakSelf) {
			 self.placeHolderImageView.hidden = [weakSelf setupImageViewWithScrollView];
		 }
	 } failure:
	 ^(NSError *error) {
		 
	 }];
}

- (BOOL)setupImageViewWithScrollView {
	UIImage *image = self.imageView.image;
	CGRect imageRect = CGRectMake(0.0F, 0.0F, image.size.width, image.size.height);
	if (CGRectIsEmpty(imageRect)) {
		return NO;
	}
	self.imageView.frame = imageRect;
	
	self.scrollView.contentSize = image.size;

	CGFloat scaleWidth = self.scrollView.frame.size.width / self.scrollView.contentSize.width;
	CGFloat scaleHeight = self.scrollView.frame.size.height / self.scrollView.contentSize.height;
	CGFloat minScale = MIN(scaleWidth, scaleHeight);

	self.scrollView.minimumZoomScale = minScale;
	self.scrollView.maximumZoomScale = 6.0 * minScale;
	
	self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
	[self.scrollView setZoomScale:minScale animated:NO];
	[self centerImageViewinScrollView];
	
	return YES;
}

- (void)centerImageViewinScrollView {
	if (!self.imageView || CGRectIsEmpty(self.imageView.frame)) {
		return;
	}
	CGRect scrollViewBounds = self.bounds;
	
	// Sometimes the imageView frame is not up to date with the zoom scale yet, so we create the rect it should be
	CGRect imageViewFrame = CGRectMake(0, 0, self.imageView.image.size.width * self.scrollView.zoomScale,
									   self.imageView.image.size.height * self.scrollView.zoomScale);
	CGPoint origin = imageViewFrame.origin;
	
	origin.x = (scrollViewBounds.size.width - imageViewFrame.size.width) / 2.0;
	if (origin.x < 0.0) {
		origin.x = 0.0;
	}
	
	origin.y = (scrollViewBounds.size.height - imageViewFrame.size.height) / 2.0;
	if (origin.y < 0.0) {
		origin.y = 0.0;
	}
	
	[self.scrollView addTopLayoutConstraintWithChild:self.imageView value:origin.y];
	[self.scrollView addLeftLayoutConstraintWithChild:self.imageView value:origin.x];
}


#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self centerImageViewinScrollView];
}

@end
