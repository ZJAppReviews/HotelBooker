//
//  SearchViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "SearchViewController.h"
#import "HotelCompact.h"
#import "HotelListViewController.h"
#import "HotelApi.h"
#import "CalendarViewController.h"
#import "NSDate+DateFormat.h"
#import "LocationUtils.h"
#import "UIViewController+ViewControllerUtils.h"
#import "SelectionTableViewController.h"
#import "SettingsViewControllerDelegate.h"

@interface SearchViewController ()

@property (nonatomic) SearchData *searchData;
@property (nonatomic) CLGeocoder *geocoder;
@property (nonatomic) CLLocation *currentGeolocation;
@property (nonatomic) SettingsViewControllerDelegate *settingsViewControllerDelegate;

@end

@implementation SearchViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.locationSearchBar.dataSource = self;
	
	self.currentLocationImageView.animationImages = @[[UIImage imageNamed:@"ic_location_enabled"],
													  [UIImage imageNamed:@"ic_location_disabled"]];
	self.currentLocationImageView.animationDuration = 1.0;
	
	self.searchData = [SearchData new];
	self.geocoder = [CLGeocoder new];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Current Location

- (void)setCurrentGeolocation:(CLLocation *)currentGeolocation {
	_currentGeolocation = currentGeolocation;
	if (currentGeolocation) {
		self.currentLocationImageView.image = [UIImage imageNamed:@"ic_location_enabled"];
	}
	else {
		self.currentLocationImageView.image = [UIImage imageNamed:@"ic_location_disabled"];
	}
}

- (IBAction)currentLocationClicked:(UIButton *)sender {
	sender.enabled = NO;
	[self.currentLocationImageView startAnimating];
	
	[LocationUtils.sharedInstance getLocationWithCompletionHandler:
	 ^(CLLocation *location, NSError *error) {
		 [self.currentLocationImageView stopAnimating];
		 sender.enabled = YES;
		 if (location) {
			 self.currentGeolocation = location;
			 [self reverseGeocode:location];
		 }
		 else if (error) {
			 [self shakeCurrentLocationContainer];
		 }
	 }];
}

- (void)reverseGeocode:(CLLocation *)location {
	[self.geocoder reverseGeocodeLocation:location completionHandler:
	 ^(NSArray *placemarks, NSError *error) {
		 if (placemarks && placemarks.count > 0) {
			 self.locationSearchBar.text = [placemarks.firstObject description];
		 }
		 else {
			 // couldn;t find name for location, so use lat, long
			 self.locationSearchBar.text = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
		 }
	 }];
}

- (void)shakeCurrentLocationContainer {
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.duration = 0.05;
	animation.repeatCount = 6;
	animation.autoreverses = YES;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.currentLocationContainer.center.x - 5.0F, self.currentLocationContainer.center.y)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.currentLocationContainer.center.x + 5.0F, self.currentLocationContainer.center.y)];
	[self.currentLocationContainer.layer addAnimation:animation forKey:@"position"];
}

#pragma mark - Date Selection

- (IBAction)unwindFromSelectDates:(UIStoryboardSegue *)segue {
	//segue.source is the navigation controller - first view controller will be calendar view controller
	if ([segue.identifier isEqualToString:@"cancelDateSelection"]) {
		// date selection cancelled
	}
	else if ([segue.identifier isEqualToString:@"confirmDateSelection"]) {
		CalendarViewController *calendarViewController = segue.sourceViewController;
		self.searchData.checkInDate = calendarViewController.selectedCheckInDate;
		self.searchData.checkOutDate = calendarViewController.selectedCheckOutDate;
		if (self.searchData.checkInDate) {
			self.checkInDayLabel.hidden = NO;
			self.checkInDayLabel.text = [self.searchData.checkInDate formatDayOfWeek];
			[self.checkInDateButton setTitle:[self.searchData.checkInDate formatDayMonth] forState:UIControlStateNormal];
		}
		else {
			self.checkInDayLabel.hidden = YES;
			[self.checkInDateButton setTitle:NSLocalizedString(@"Please select", @"") forState:UIControlStateNormal];

		}
		if (self.searchData.checkOutDate) {
			self.checkOutDayLabel.hidden = NO;
			self.checkOutDayLabel.text = [self.searchData.checkOutDate formatDayOfWeek];
			[self.checkOutDateButton setTitle:[self.searchData.checkOutDate formatDayMonth] forState:UIControlStateNormal];

		}
		else {
			self.checkOutDayLabel.hidden = YES;
			[self.checkOutDateButton setTitle:NSLocalizedString(@"Please select", @"") forState:UIControlStateNormal];

		}
	}
}

#pragma mark - Search

- (IBAction)searchClicked:(id)sender {
	[self validateAndSearch];
}

- (void)validateAndSearch {
	if (self.validate) {
		if (self.currentGeolocation) {
			self.searchData.location = self.currentGeolocation;
		} else {
			CLPlacemark *locationPlacemark = self.locationSearchBar.selectedResult;
			self.searchData.location = locationPlacemark.location;
		}
		self.searchData.numAdults = self.numberOfGuestStepper.value;
		[self performSegueWithIdentifier:@"ShowResults" sender:self];
	}
}

- (BOOL)validate {
	
	if (!self.currentGeolocation &&
		(!self.locationSearchBar.selectedResult ||
		 ![self.locationSearchBar.selectedResult isKindOfClass:[CLPlacemark class]])) {
		[self showErrorMessage:@"Please select a destination"];
		return false;
	}
	
	if (!self.searchData.checkInDate || !self.searchData.checkOutDate) {
		[self showErrorMessage:@"Please select some dates"];
		return false;
	}
	
	return true;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.currentGeolocation = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self validateAndSearch];
}

#pragma mark - SearchBarWithResultsDataSource

- (void)searchBarWithResults:(SearchBarWithResults *)searchBar completionsForString:(NSString *)string completionHandler:(void (^)(NSArray *, NSError *error))handler {
	[self.geocoder cancelGeocode];
	[self.geocoder geocodeAddressString:string completionHandler:
	 ^(NSArray *placemarks, NSError *error) {
		 if (!error && placemarks && placemarks.count > 0) {
			 // de-duplicate
			 NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:placemarks];
			 placemarks = [orderedSet array];
			 handler(placemarks, nil);
		 } else {
			 handler(nil, error);
		 }
	 }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"selectCheckInDate"] ||
		[segue.identifier isEqualToString:@"selectCheckOutDate"]) {
		UINavigationController *navController = segue.destinationViewController;
		CalendarViewController *viewController = navController.viewControllers.firstObject;
		viewController.selectedCheckInDate = self.searchData.checkInDate;
		viewController.selectedCheckOutDate = self.searchData.checkOutDate;
		viewController.selectingCheckOutDate = [segue.identifier isEqualToString:@"selectCheckOutDate"];
	}
	else if ([segue.identifier isEqualToString:@"ShowResults"]) {
		HotelListViewController *hotelListViewController = segue.destinationViewController;
		hotelListViewController.searchData = self.searchData;
	}
	else if ([segue.identifier isEqualToString:@"ShowSettings"]) {
		UINavigationController *navController = segue.destinationViewController;
		SelectionTableViewController *selectionViewController = navController.viewControllers.firstObject;
		self.settingsViewControllerDelegate = [[SettingsViewControllerDelegate alloc] initWithSelectionTableViewController:selectionViewController];
	}
}

- (IBAction)unwindFromBookingConfirmation:(UIStoryboardSegue *)segue {
	
}

@end
