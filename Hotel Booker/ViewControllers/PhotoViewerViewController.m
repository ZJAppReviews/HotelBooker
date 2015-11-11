//
//  PhotoViewerViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "PhotoViewerViewController.h"
#import "HotelApi.h"
#import "UIViewController+ViewControllerUtils.h"
#import "UIView+ViewUtils.h"
#import "PhotoViewerCell.h"

#define TEMP_IMAGE_TAG 976431

@class PhotoScrollViewDelegate;

@interface PhotoViewerViewController ()

@property (nonatomic) HotelMediaResponse *mediaResponse;
@property (nonatomic) NSIndexPath *indexPathPreRotation;
@property (nonatomic) PhotoScrollViewDelegate *photoScrollViewDelegate;
@property (nonatomic) BOOL suppressReloadOnRelayout;

@end

@implementation PhotoViewerViewController

static NSString * const reuseIdentifier = @"PhotoViewerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_suppressReloadOnRelayout = NO;
	
	[self.activityIndicator startAnimating];
	[HotelApi.sharedInstance getMedia:self.hotelCompact.hotelId success:
	 ^(HotelMediaResponse *mediaResponse) {
		 [self.activityIndicator stopAnimating];
		 [mediaResponse.mediaItemsContainer removeItemsOfType:MediaItemTypeGallery];
		 self.mediaResponse = mediaResponse;
		 [self.collectionView reloadData];
		 [self updateNavTitle];
	} failure:
	 ^(NSError *error) {
		 [self showErrorMessage:NSLocalizedString(@"Unable to retrieve images for this hotel", @"")];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	PhotoViewerCell *cell = self.collectionView.visibleCells.firstObject;
	self.indexPathPreRotation = [self.collectionView indexPathForCell:cell];
	
	// Put a temporary UIImageView on screen to cover the strange animation that occurs when we preserve the current
	// scroll page
	[cell.scrollView setZoomScale:cell.scrollView.minimumZoomScale animated:NO];
	
	UIImageView *imageView = nil;
	if (cell.placeHolderImageView.hidden) {
		imageView = [[UIImageView alloc] initWithImage:cell.imageView.image];
	}
	else {
		imageView = [[UIImageView alloc] initWithImage:cell.placeHolderImageView.image];
	}
	CGSize size = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:self.indexPathPreRotation];
	imageView.frame = CGRectMake(self.collectionView.contentInset.left, self.collectionView.contentInset.top, size.width, size.height);
	imageView.tag = TEMP_IMAGE_TAG;
	imageView.backgroundColor = UIColor.blackColor;
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:imageView aboveSubview:self.collectionView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.collectionView scrollToItemAtIndexPath:self.indexPathPreRotation
								atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
										animated:NO];

	UIView *imageView = [self.view viewWithTag:TEMP_IMAGE_TAG];
	[imageView removeFromSuperview];
	
	self.indexPathPreRotation = nil;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	if (UIDevice.currentDevice.systemVersion.floatValue >= 8.0) {
		[self updateOnLayoutSubViews];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if (UIDevice.currentDevice.systemVersion.floatValue < 8.0) {
		[self updateOnLayoutSubViews];
	}
}

- (void)updateOnLayoutSubViews {
	if (self.suppressReloadOnRelayout) {
		self.suppressReloadOnRelayout = NO;
	}
	else {
		// cause a resize of the collection view cells on orientation change
		[self.collectionView.collectionViewLayout invalidateLayout];
		[self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
	}
}

- (void)updateNavTitle {
	if (self.mediaResponse) {
		NSUInteger page = round(self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
		self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"%d of %d", @""),
								 page + 1,
								 self.mediaResponse.mediaItemsContainer.mediaItems.count];
	}
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mediaResponse.mediaItemsContainer.mediaItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoViewerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	if (cell.gestureRecognizers.count == 0) {
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
		tap.numberOfTapsRequired = 1;
		[cell addGestureRecognizer:tap];
	}
	
	[self.collectionView.collectionViewLayout invalidateLayout];
	
	cell.mediaItem = self.mediaResponse.mediaItemsContainer.mediaItems[indexPath.row];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = self.collectionView.frame.size;
	size.width -= (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
	size.height -= (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom);
	return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self updateNavTitle];
}


#pragma mark - PhotoViewerCell gestures

- (void)imageTapped:(UITapGestureRecognizer *)gesture {
	self.suppressReloadOnRelayout = YES;
	BOOL navBarhidden = self.navigationController.navigationBarHidden;
	[self.navigationController setNavigationBarHidden:!navBarhidden animated:YES];
	[self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
	return self.navigationController.navigationBarHidden;
}

@end
