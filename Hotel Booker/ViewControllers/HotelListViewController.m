//
//  HotelListViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelListViewController.h"
#import "HotelDetailViewController.h"
#import "HotelApi.h"
#import "HotelCompact.h"
#import "HotelTableViewCell.h"
#import "ResultsMapViewController.h"
#import "Config.h"
#import "UIViewController+ViewControllerUtils.h"
#import "SelectionTableViewController.h"
#import "HotelSearchResultFilterSet.h"
#import "HotelSearchResultAmenityFilter.h"
#import "HotelSearchResultDistanceFilter.h"
#import "HotelSearchResultPriceFilter.h"
#import "HotelSearchResultStarRatingFilter.h"

@interface HotelListViewController () <SelectionTableViewControllerDelegate>

@property (nonatomic) HotelApiRequest *currentRequest;
@property (nonatomic) HotelSearchResult *hotelSearchResult;
@property (nonatomic) NSArray /* HotelCompact */ *hotels;
@property (nonatomic) HotelSearchResultSortType *sortType;
@property (nonatomic) HotelSearchResultFilterSet *filters;

@end

@implementation HotelListViewController

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)viewDidLoad {
	CGFloat screenWidth = MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
	CGFloat rowHeight = screenWidth / HOTEL_LIST_ELEMENT_ASPECT_RATIO;
	self.tableView.rowHeight = rowHeight;
	self.tableView.separatorInset = UIEdgeInsetsZero;
	self.sortType = [[HotelSearchResultSortType alloc] initWithType:HotelSearchResultSortTypeOptionPriceLowToHigh];
	self.filters = [HotelSearchResultFilterSet new];
	
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.currentRequest) {
		[self showActivityIndicator];
	}
	else {
		[self hideActivityIndicator];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self hideActivityIndicator];
	
	if (self.currentRequest) {
		[self.currentRequest cancel];
		self.currentRequest = nil;
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Searching

- (void)setSearchData:(SearchData *)searchData {
	_searchData = searchData;
	
	if (searchData) {
		[self makeSearchRequest];
	}
}

- (void)makeSearchRequest {
	[self showActivityIndicator];
	
	if (self.currentRequest) {
		[self.currentRequest cancel];
		self.currentRequest = nil;
	}
	
	__weak HotelListViewController *weakSelf = self;
	
	self.currentRequest = [HotelApi.sharedInstance getHotels:self.searchData
							   success:
	 ^(HotelSearchResult *hotelSearchResult) {
		 if (weakSelf) {
			 [weakSelf hideActivityIndicator];
			 
			 weakSelf.currentRequest = nil;
			 
			 weakSelf.hotelSearchResult = hotelSearchResult;
			 [weakSelf sortAndFilter:NSLocalizedString(@"Sorting", @"") recoverableIfNoResults:NO];
		 }
	 } failure:^(NSError *error) {
		 if (weakSelf) {
			 [weakSelf hideActivityIndicator];
		 
			 weakSelf.currentRequest = nil;

			 [weakSelf showNoResultsIndicator:NO];
		 }
	 }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowMap"]) {
		UINavigationController *navController = segue.destinationViewController;
		ResultsMapViewController* mapViewController = navController.viewControllers.firstObject;
		mapViewController.searchData = self.searchData;
		mapViewController.hotels = self.hotels;
	}
	else if ([segue.identifier isEqualToString:@"ShowDetail"]) {
	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	    HotelCompact *hotel = self.hotels[indexPath.row];
		HotelDetailViewController *hotelDetailViewController = segue.destinationViewController;
		hotelDetailViewController.searchData = self.searchData;
	    hotelDetailViewController.hotelCompact = hotel;
	}
	else if ([segue.identifier isEqualToString:@"ShowSortSelection"]) {
		UINavigationController *navController = segue.destinationViewController;
		SelectionTableViewController *selectionTableViewController = navController.viewControllers.firstObject;
		[self prepareSelectionViewControllerForSorting:selectionTableViewController];
	}
	else if ([segue.identifier isEqualToString:@"ShowFilterSelection"]) {
		UINavigationController *navController = segue.destinationViewController;
		SelectionTableViewController *selectionTableViewController = navController.viewControllers.firstObject;
		[self prepareSelectionViewControllerForFiltering:selectionTableViewController];
	}
	
}

- (IBAction)unwindFromMap:(UIStoryboardSegue *)segue {
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.hotels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelResultCell" forIndexPath:indexPath];

	cell.hotel = self.hotels[indexPath.row];
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return NO;
}

#pragma mark - Activity Indicator

- (void)showActivityIndicator {
	[self.indicatorContainer.superview bringSubviewToFront:self.indicatorContainer];
	self.indicatorContainer.hidden = NO;
	[self.indicator startAnimating];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideActivityIndicator {
	self.indicatorContainer.hidden = YES;
	[self.indicator stopAnimating];
	[self.indicatorContainer.superview sendSubviewToBack:self.indicatorContainer];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - No Results Indicator

- (void)showNoResultsIndicator:(BOOL)recoverable {
	if (!recoverable) {
		// if the user cannot recover by changing filters, hide the filter buttons
		[self.noResultsContainer.superview bringSubviewToFront:self.noResultsContainer];
	}
	self.noResultsContainer.hidden = NO;
}

- (void)hideNoResultsIndicator {
	self.noResultsContainer.hidden = YES;
	[self.noResultsContainer.superview sendSubviewToBack:self.noResultsContainer];
}

#pragma mark - Sorting and Filtering

- (void)prepareSelectionViewControllerForSorting:(SelectionTableViewController *)selectionViewController {
	selectionViewController.delegate = self;
	SelectionTableViewControllerDataSource *dataSource = [SelectionTableViewControllerDataSource new];
	dataSource.titleString = NSLocalizedString(@"Sort", @"");
	dataSource.objects = [HotelSearchResultSortType allTypes];
	if (self.sortType) {
		[dataSource setSelectedObjects:@[self.sortType]];
	}
	dataSource.allowsMultipleSelection = NO;
	selectionViewController.dataSource = dataSource;
}

- (void)sortTypeSelected:(HotelSearchResultSortType *)sortType {
	self.sortType = sortType;
	
	[self sortAndFilter:NSLocalizedString(@"Sorting", @"") recoverableIfNoResults:YES];
}

- (void)prepareSelectionViewControllerForFiltering:(SelectionTableViewController *)selectionViewController {
	selectionViewController.delegate = self;
	
	NSMutableArray *dataSources = [NSMutableArray new];
	
	// Price Range
	SelectionTableViewControllerDataSource *dataSource = [SelectionTableViewControllerDataSource new];
	dataSource.titleString = NSLocalizedString(@"Price Range", @"");
	dataSource.objects = [HotelSearchResultPriceFilter filtersForSearchResult:self.hotelSearchResult];
	[dataSource setSelectedObjects:self.filters.priceFilters.allObjects];
	dataSource.allowsMultipleSelection = YES;
	dataSource.objectsDescriptionProvider =
	^NSString *(NSArray *filters) {
		return [HotelSearchResultPriceFilter descriptionForFilters:filters];
	};
	[dataSources addObject:dataSource];
	
	// Star Rating
	dataSource = [SelectionTableViewControllerDataSource new];
	dataSource.titleString = NSLocalizedString(@"Star Rating", @"");
	dataSource.objects = [HotelSearchResultStarRatingFilter filtersForSearchResult:self.hotelSearchResult];
	[dataSource setSelectedObjects:self.filters.starRatingFilters.allObjects];
	dataSource.allowsMultipleSelection = YES;
	dataSource.objectsDescriptionProvider =
	^NSString *(NSArray *filters) {
		return [HotelSearchResultStarRatingFilter descriptionForFilters:filters];
	};
	[dataSources addObject:dataSource];

	// Distance
	dataSource = [SelectionTableViewControllerDataSource new];
	dataSource.titleString = NSLocalizedString(@"Distance", @"");
	dataSource.objects = [HotelSearchResultDistanceFilter filtersForSearchResult:self.hotelSearchResult];
	[dataSource setSelectedObjects:self.filters.distanceFilters.allObjects];
	dataSource.allowsMultipleSelection = YES;
	dataSource.objectsDescriptionProvider =
	^NSString *(NSArray *filters) {
		return [HotelSearchResultDistanceFilter descriptionForFilters:filters];
	};
	[dataSources addObject:dataSource];
	
	// Amenities
	dataSource = [SelectionTableViewControllerDataSource new];
	dataSource.titleString = NSLocalizedString(@"Amenities", @"");
	dataSource.objects = [HotelSearchResultAmenityFilter filtersForSearchResult:self.hotelSearchResult];
	[dataSource setSelectedObjects:self.filters.amenityFilters.allObjects];
	dataSource.allowsMultipleSelection = YES;
	[dataSources addObject:dataSource];

	// Container data source that contains the various filters
	SelectionTableViewControllerDataSource *containerDataSource = [SelectionTableViewControllerDataSource new];
	containerDataSource.titleString = NSLocalizedString(@"Filters", @"");
	containerDataSource.objects = dataSources;
	containerDataSource.allowsMultipleSelection = NO;
	selectionViewController.dataSource = containerDataSource;
}

- (void)sortAndFilter:(NSString *)indicatorText recoverableIfNoResults:(BOOL)recoverableIfNoResults {
	self.indicatorLabel.text = indicatorText;
	[self showActivityIndicator];
	self.hotels = [self.hotelSearchResult hotelsFilteredBy:self.filters andSortedBy:self.sortType];
	[self.tableView reloadData];

	// allow access to map view, if we have some results
	self.navigationItem.rightBarButtonItem.enabled = self.hotels.count > 0;
	
	if (self.hotels.count == 0) {
		[self showNoResultsIndicator:recoverableIfNoResults];
	}
	else {
		[self hideNoResultsIndicator];
	}
	
	self.tableView.contentOffset = CGPointMake(0.0F, 0.0F);
	[self hideActivityIndicator];
}

#pragma mark - SelectionTableViewControllerDelegate

- (void)selectionTableViewController:(SelectionTableViewController *)selectionTableViewController objectsSelected:(NSArray *)objects {
	if ([selectionTableViewController.dataSource.objects.firstObject isKindOfClass:HotelSearchResultSortType.class]) {
		if (objects.count > 0 && [objects.firstObject isKindOfClass:HotelSearchResultSortType.class]) {
			[self sortTypeSelected:objects.firstObject];
		}
	}
	else if ([selectionTableViewController.dataSource isBranchNode]) {
		// pick out all selected filters
		[self.filters removeAllObjects];
		for (id obj in selectionTableViewController.dataSource.objects) {
			if ([obj isKindOfClass:SelectionTableViewControllerDataSource.class]) {
				SelectionTableViewControllerDataSource *dataSource = (SelectionTableViewControllerDataSource *)obj;
				[self.filters addFiltersFromArray:[dataSource selectedObjects]];
			}
		}
		[self sortAndFilter:NSLocalizedString(@"Filtering", @"") recoverableIfNoResults:YES];
	}
}

- (void)selectionTableViewControllerCancelled:(SelectionTableViewController *)selectionTableViewController {
}

@end
