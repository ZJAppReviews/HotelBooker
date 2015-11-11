//
//  RateDetailViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 30/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RateDetailViewController.h"
#import "HotelApi.h"
#import "UIViewController+ViewControllerUtils.h"
#import "RateDetailTotalBreakdownTableViewCell.h"
#import "RateDetailTableViewCell.h"
#import "BookingViewController.h"
#import "UserSettings.h"

#define ROW_HEIGHT_TOTAL_AND_BREAKDOWN_UNEXPANDED 167.0F
#define ROW_HEIGHT_ROOM_RATE_DESCRIPTION 110.0F

@interface RateDetailViewController () <RateDetailTotalBreakdownTableViewCellDelegate>

@property (nonatomic) NSArray /* RoomRateDescription */ *roomRateDescriptions;
@property (nonatomic) RateDetailTotalBreakdownTableViewCell* totalBreakdownCell;

@end

@implementation RateDetailViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.bookButton.enabled = UserSettings.sharedInstance.resultsEnvironment.allowsBooking;
	if (!self.bookButton.enabled) {
		self.bookButton.alpha = 0.5;
	}
	
	self.roomRateDescriptions = [self.rateDetail getFilteredRoomRateDescriptions];
	[self.tableView registerNib:[UINib nibWithNibName:@"RateDetailTableViewCell" bundle:nil]
		 forCellReuseIdentifier:@"RateDetailTableViewCell"];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	// trigger resize of cells
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
	[self.totalBreakdownCell willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	[self.totalBreakdownCell didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (CGFloat)getWidthAvailable {
	BOOL isLandscape = UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation);
	CGRect bounds = UIScreen.mainScreen.bounds;
	return isLandscape ? MAX(bounds.size.width, bounds.size.height) : MIN(bounds.size.width, bounds.size.height);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return self.roomRateDescriptions.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		if (!self.totalBreakdownCell) {
			self.totalBreakdownCell = [tableView dequeueReusableCellWithIdentifier:@"RateDetailTotalBreakdownTableViewCell" forIndexPath:indexPath];
		}
		
		self.totalBreakdownCell.searchData = self.searchData;
		self.totalBreakdownCell.rateDetail = self.rateDetail;
		self.totalBreakdownCell.delegate = self;
		return self.totalBreakdownCell;
	}
	else {
		RateDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RateDetailTableViewCell" forIndexPath:indexPath];
		
		NSInteger index = indexPath.row - 1;
		cell.index = index;
		cell.roomRateDescription = self.roomRateDescriptions[index];
		
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		CGFloat extraHeight = 0.0F;
		if (self.totalBreakdownCell) {
			extraHeight  = self.totalBreakdownCell.breakdownHeight;
		}
		return ROW_HEIGHT_TOTAL_AND_BREAKDOWN_UNEXPANDED + extraHeight;
	}
	else {
		NSInteger index = indexPath.row - 1;
		return [RateDetailTableViewCell heightForCellWithHotelRateDetail:self.roomRateDescriptions[index] andWidth:[self getWidthAvailable]];
	}
}

#pragma mark - RateDetailTotalBreakdownTableViewCellDelegate

- (void)cell:(RateDetailTotalBreakdownTableViewCell *)cell breakdownExpanded:(BOOL)expanded {
	// trigger an update to the cell sizes
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
	// scrollViewDidScroll does not get called by the system, as a result of the begin/endUpdates
	//causing a scroll. So, we call it manually, to ensure the top image is updated.
	[self scrollViewDidScroll:self.tableView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowBookingForm"]) {
		BookingViewController *bookingViewController = segue.destinationViewController;
		bookingViewController.rateDetail = self.rateDetail;
		bookingViewController.searchData = self.searchData;
		bookingViewController.hotelCompact = self.hotelCompact;
		bookingViewController.hotelDetailsResult = self.hotelDetailsResult;
	}
}

@end
