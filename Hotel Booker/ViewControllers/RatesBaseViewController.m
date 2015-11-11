//
//  RatesBaseViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 19/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RatesBaseViewController.h"
#import "HotelApi.h"
#import "HotelRatesTableHeader.h"
#import "UIView+ViewUtils.h"

static NSString *HotelRatesTableHeaderReuseId = @"HotelRatesTableHeader";

@implementation RatesBaseViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self configureView];
	
	[self.tableView registerClass:[HotelRatesTableHeader class] forHeaderFooterViewReuseIdentifier:HotelRatesTableHeaderReuseId];
}

- (void)configureView {
	__weak RatesBaseViewController *weakSelf = self;
	
	// get a room-type image, if there is one, otherwise, use the hotel thumbnail
	[HotelApi.sharedInstance getMedia:self.hotelCompact.hotelId success:
	 ^(HotelMediaResponse *mediaResponse) {
		 if (weakSelf) {
			 MediaItem *roomMediaItem = [mediaResponse.mediaItemsContainer mediaItemOfType:MediaItemTypeRoom];
			 if (roomMediaItem) {
				 [roomMediaItem getImageForImageView:weakSelf.imageView success:nil failure:nil];
			 }
			 else {
				 [HotelApi.sharedInstance getHotelThumbnail:weakSelf.hotelCompact.hotelId forImageView:weakSelf.imageView];
			 }
		 }
	 } failure:
	 ^(NSError *error) {
		 if (weakSelf) {
			 [HotelApi.sharedInstance getHotelThumbnail:weakSelf.hotelCompact.hotelId forImageView:weakSelf.imageView];
		 }
	 }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	// sometimes after rotation, the scrolloffset has changed, but the delegate method has not been called
	[self scrollViewDidScroll:self.tableView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	HotelRatesTableHeader *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:HotelRatesTableHeaderReuseId];
	
	if (!header) {
		header = [[HotelRatesTableHeader alloc] initWithReuseIdentifier:HotelRatesTableHeaderReuseId];
	}
	
	header.searchData = self.searchData;
	
	return header;
}

#pragma mark - UIScollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	static CGFloat originalImageHeight = -1.0;
	if (originalImageHeight == -1.0) {
		originalImageHeight = self.imageHeightConstraint.constant;
	}
	
	// Parallax scroll the main image
	CGFloat scrollYOffset = scrollView.contentOffset.y;
	CGFloat newImageHeight = originalImageHeight - scrollYOffset;
	if (newImageHeight > 0.0) {
		self.imageHeightConstraint.constant = newImageHeight;
		self.imageTopOffsetConstraint.constant = scrollYOffset;
	}
	else {
		self.imageHeightConstraint.constant = 0.0;
	}
}

@end
