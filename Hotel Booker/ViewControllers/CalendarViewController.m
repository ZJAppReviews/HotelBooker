//
//  CalendarViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 13/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarViewCell.h"
#import "CalendarHeaderView.h"
#import "NSDate+DateFormat.h"
#import "NSDate+DateUtils.h"
#import "Palette.h"
#import "UILabel+LabelUtils.h"

@interface CalendarViewController ()

@property NSDateComponents *minimumDateComponents;
@property NSDateComponents *maximumDateComponents;

@end

@implementation CalendarViewController

- (void)setMinimumDate:(NSDate *)minimumDate {
	_minimumDate = minimumDate;
	
	self.minimumDateComponents = [minimumDate getYearMonthDayComponents];
	
	self.headerMonthLabel.text = [minimumDate formatMonthYear];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
	_maximumDate = maximumDate;
	
	self.maximumDateComponents = [maximumDate getYearMonthDayComponents];
}

- (void)setSelectedCheckInDate:(NSDate *)selectedCheckInDate {
	_selectedCheckInDate = selectedCheckInDate;
	
	if (selectedCheckInDate) {
		self.selectedCheckInDateLabel.text = [selectedCheckInDate formatDayMonthYear];
	} else {
		self.selectedCheckInDateLabel.text = NSLocalizedString(@"Please select a date", @"");
	}
	
	[self updateDoneButton];
}

- (void)setSelectedCheckOutDate:(NSDate *)selectedCheckOutDate {
	_selectedCheckOutDate = selectedCheckOutDate;
	
	if (selectedCheckOutDate) {
		self.selectedCheckOutDateLabel.text = [selectedCheckOutDate formatDayMonthYear];
	} else {
		self.selectedCheckOutDateLabel.text = NSLocalizedString(@"Please select a date", @"");
	}
	
	[self updateDoneButton];
}

- (void)setSelectingCheckOutDate:(BOOL)selectingCheckOutDate {
	_selectingCheckOutDate = selectingCheckOutDate;
	
	UIColor *newCheckInBgColor;
	UIColor *newCheckInTextColor;
	UIColor *newCheckInDateTextColor;
	UIColor *newCheckOutBgColor;
	UIColor *newCheckOutTextColor;
	UIColor *newCheckOutDateTextColor;
	if (selectingCheckOutDate) {
		newCheckInBgColor = UIColor.clearColor;
		newCheckInTextColor = TRAVELPORT_GREEN;
		newCheckInDateTextColor = UIColor.blackColor;
		newCheckOutBgColor = TRAVELPORT_GREEN;
		newCheckOutTextColor = UIColor.whiteColor;
		newCheckOutDateTextColor = UIColor.whiteColor;
	} else {
		newCheckInBgColor = TRAVELPORT_GREEN;
		newCheckInTextColor = UIColor.whiteColor;
		newCheckInDateTextColor = UIColor.whiteColor;
		newCheckOutBgColor = UIColor.clearColor;
		newCheckOutTextColor = TRAVELPORT_GREEN;
		newCheckOutDateTextColor = UIColor.blackColor;
	}
	[UIView animateWithDuration:0.3 animations:^{
		self.selectedCheckInDateContainer.backgroundColor = newCheckInBgColor;
		self.selectedCheckOutDateContainer.backgroundColor = newCheckOutBgColor;
	}];
	[self.selectedCheckInDateTitleLabel setTextColorAnimated:newCheckInTextColor];
	[self.selectedCheckInDateLabel setTextColorAnimated:newCheckInDateTextColor];
	[self.selectedCheckOutDateTitleLabel setTextColorAnimated:newCheckOutTextColor];
	[self.selectedCheckOutDateLabel setTextColorAnimated:newCheckOutDateTextColor];
}

- (IBAction)checkInTapped:(id)sender {
	self.selectingCheckOutDate = NO;
}

- (IBAction)checkOutTapped:(id)sender {
	self.selectingCheckOutDate = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!self.minimumDate) {
		self.minimumDate = [NSDate date];
	}
	
	if (!self.maximumDate) {
		self.maximumDate = [[NSDate date] dateByAddingTimeInterval:365 * 24 * 60 *60];
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// ensure the correct header is highlighted and values are correct
	self.selectedCheckInDate = self.selectedCheckInDate;
	self.selectedCheckOutDate = self.selectedCheckOutDate;
	self.selectingCheckOutDate = self.selectingCheckOutDate;

	[self updateDoneButton];
}

- (void)updateDoneButton {
	if (self.selectedCheckInDate && self.selectedCheckOutDate) {
		// both dates set, so show done button
		self.navigationItem.rightBarButtonItem = self.doneButton;
	}
	else {
		// hide done button
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	if (UIDevice.currentDevice.systemVersion.floatValue >= 8.0) {
		// cause a resize of the collection view cells on orientation change
		[self.collectionView.collectionViewLayout invalidateLayout];
	[self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if (UIDevice.currentDevice.systemVersion.floatValue < 8.0) {
		// prevents displaced arrows on cells when on iOS7
		[self.collectionView.collectionViewLayout invalidateLayout];
		// this also prevents strange layout when this screen is first shown on iOS7
		[self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
	}
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSDate *dateForSectionMonth = [self.minimumDate dateByAddingMonths:section];
	NSInteger weeksInMonth = dateForSectionMonth.weeksInMonth;
	
	return 7 * weeksInMonth;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CalendarViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarViewCell" forIndexPath:indexPath];
	[cell reset];
	
	NSDate *dateForSectionMonth = [self.minimumDate dateByAddingMonths:indexPath.section];
	NSDate *firstDayOfMonth = dateForSectionMonth.firstDayOfMonth;

	// days in month start at 1
	NSInteger dayOffset = (indexPath.row + 1) - [firstDayOfMonth weekDayRelativeTo:GregorianWeekDayMonday];
	if (dayOffset >= 0 && dayOffset < dateForSectionMonth.daysInMonth) {
		cell.date = [firstDayOfMonth dateByAddingDays:dayOffset];
		cell.minimumDate = self.minimumDate;
		cell.maximumDate = self.maximumDate;
		cell.selectedCheckInDate = self.selectedCheckInDate;
		cell.selectedCheckOutDate = self.selectedCheckOutDate;
	}
	[cell updateView];
	
	return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	// one section per month that we want to show
	return MAX(0, (self.maximumDateComponents.month - self.minimumDateComponents.month + 1) +
			   12 * (self.maximumDateComponents.year - self.minimumDateComponents.year));
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
		   viewForSupplementaryElementOfKind:(NSString *)kind
								 atIndexPath:(NSIndexPath *)indexPath {
	CalendarHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
																			 withReuseIdentifier:@"CalendarHeaderView"
																					forIndexPath:indexPath];
	
	headerView.date = [self.minimumDate dateByAddingMonths:indexPath.section];
	
	return headerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// ensure top header matches current section header
	NSIndexPath *firstVisibleIndexPath = [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];
	if (firstVisibleIndexPath) {
		NSDate *dateForMonthSection = [self.minimumDate dateByAddingMonths:firstVisibleIndexPath.section];
		self.headerMonthLabel.text = [dateForMonthSection formatMonthYear];
	}
}

#pragma mark - UICollectionViewDelgate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	CalendarViewCell *cell = (CalendarViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
	NSDate *date = cell.date;
	
	if (!date) {
		return;
	}
	
	if ([date isEarlierDayThan:self.minimumDate] || [date isLaterDayThan:self.maximumDate]) {
		return;
	}
	
	if (!self.selectingCheckOutDate) {
		self.selectedCheckInDate = date;
		if (self.selectedCheckOutDate && ![self.selectedCheckOutDate isLaterDayThan:date]) {
			// new check-in date is incompatible with the check-out date
			self.selectedCheckOutDate = nil;
		}
	} else  {
		self.selectedCheckOutDate = date;
		if (self.selectedCheckInDate && ![self.selectedCheckInDate isEarlierDayThan:date]) {
			// new check-out date is incompatible with the check-in date
			self.selectedCheckInDate = nil;
		}
	}

	// toggle to choose other date
	self.selectingCheckOutDate = !self.selectingCheckOutDate;

	[self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat width = self.collectionView.frame.size.width;
	NSInteger widthRemainder = (NSInteger)width % 7;
	NSInteger extraWidth = 0;
	
	// Make the beginning and end of each row of days pick up any slack in pixels.
	// Otherwise the odd pixel gap can appear between cells
	if (widthRemainder > 0) {
		if (indexPath.row % 7 == 0) {
			extraWidth = (widthRemainder / 2) + (widthRemainder % 2);
		}
		else if (indexPath.row % 7 == 6) {
			extraWidth = widthRemainder / 2;
		}
	}
	
	NSInteger widthInt = width / 7;
	// For the height, use the shorter side to give a square in portrait but avoid huge squares in landscape mode
	NSInteger height = MIN(width, self.view.frame.size.height) / 7;
	return CGSizeMake(widthInt + extraWidth, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		// no need to show header for first section as it is a duplication of the top header
		return CGSizeZero;
	}else {
		return CGSizeMake(CGRectGetWidth(collectionView.bounds), 50);
	}
}



@end
