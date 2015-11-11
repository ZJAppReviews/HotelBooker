//
//  RatesTableViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 16/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RatesTableViewController.h"
#import "RateDetailViewController.h"
#import "HotelRatesTableViewCell.h"

@interface RatesTableViewController ()

@end

@implementation RatesTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"HotelRatesTableViewCell" bundle:nil]
		 forCellReuseIdentifier:@"HotelRatesTableViewCell"];
}

- (NSArray /* HotelRateDetail */*)rateDetails {
	return self.hotelDetailsResult.hotelDetails.hotelRateDetails;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	// trigger an update to the cell sizes
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	// trigger an update to the cell sizes
//	[self.tableView beginUpdates];
//	[self.tableView endUpdates];
}

- (CGFloat)getWidthAvailable {
	BOOL isLandscape = UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation);
	CGRect bounds = UIScreen.mainScreen.bounds;
	return isLandscape ? MAX(bounds.size.width, bounds.size.height) : MIN(bounds.size.width, bounds.size.height);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	HotelRateDetail *hotelRateDetail = self.rateDetails[indexPath.row];
	
	return [HotelRatesTableViewCell heightForCellWithHotelRateDetail:hotelRateDetail andWidth:[self getWidthAvailable]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return self.rateDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	HotelRatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelRatesTableViewCell" forIndexPath:indexPath];
	
	cell.index = indexPath.row;
	cell.hotelRateDetail = self.rateDetails[indexPath.row];
	[cell update];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self performSegueWithIdentifier:@"ShowRateDetails" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowRateDetails"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		HotelRateDetail *rateDetail = self.rateDetails[indexPath.row];
		RateDetailViewController *rateDetailViewController = segue.destinationViewController;
		rateDetailViewController.rateDetail = rateDetail;
		rateDetailViewController.searchData = self.searchData;
		rateDetailViewController.hotelCompact = self.hotelCompact;
		rateDetailViewController.hotelDetailsResult = self.hotelDetailsResult;
	}
}


@end
