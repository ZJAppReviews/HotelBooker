//
//  HotelDetailViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "MediaItem.h"
#import "RatesTableViewController.h"
#import "HotelApi.h"
#import <RestKit/UIImageView+AFNetworking.h>
#import "UIViewController+ViewControllerUtils.h"
#import "UILabel+LabelUtils.h"
#import "PhotoViewerViewController.h"

#define DEFAULT_AMENITIES_COUNT 12

@interface HotelDetailViewController ()

@property (nonatomic) HotelApiRequest *currentRequest;
@property (nonatomic) BOOL showingAllAmenities;

@end

@implementation HotelDetailViewController

- (void)setHotelCompact:(HotelCompact *)hotelCompact {
	if (_hotelCompact != hotelCompact) {
		_hotelCompact = hotelCompact;
		
		// Update the view.
		[self configureView];
		
		[self makeDetailRequest];
	}
}

- (void)configureView {
	// Update the user interface for the detail item.
	if (self.hotelCompact) {
		[self configureImage];
		[self configureMap];
		self.hotelNameLabel.text = self.hotelCompact.hotelProperty.name;
		self.distanceLabel.text = nil;
		if (self.hotelCompact.hotelProperty.distance) {
			self.distanceLabel.text = self.hotelCompact.hotelProperty.distance.formattedValue;
		}
		self.starRating.rating = self.hotelCompact.hotelProperty.hotelRating.rating.integerValue;
		
		self.priceLabel.text = nil;
		if (self.hotelCompact.rateInfo.minimumAmount) {
			self.priceLabel.text = self.hotelCompact.rateInfo.minimumAmount.formattedCurrency;
		}
		
		[self configureAmenities:NO];
		
		[self configureContactInfo];
		
	} else {
	}
	
	BOOL ratesFound = NO;
	if (self.hotelDetailsResult) {
		NSString *checkInTime = self.hotelDetailsResult.hotelDetails.checkInTime;
		if (checkInTime) {
			self.checkInLabel.text = checkInTime;
		}
		NSString *checkOutTime = self.hotelDetailsResult.hotelDetails.checkOutTime;
		if (checkOutTime) {
			self.checkOutLabel.text = checkOutTime;
		}
		
		NSArray *rateDetails = self.hotelDetailsResult.hotelDetails.hotelRateDetails;
		if (rateDetails && rateDetails.count > 0) {
			ratesFound = YES;
		}
	}

	[self.viewRatesButton setTitle:ratesFound ? NSLocalizedString(@"View Rates", @"") :NSLocalizedString(@"No Rates Found", @"") forState:UIControlStateNormal];
	self.viewRatesButton.enabled = ratesFound;
}

- (void)configureImage {
	[HotelApi.sharedInstance getHotelThumbnail:self.hotelCompact.hotelId forImageView:self.imageView];
}

- (void)configureAmenities:(BOOL)all {
	
	self.showingAllAmenities = all;
	self.amenitiesLabel.text = NSLocalizedString(@"None found", @"");
	self.showAllAmenitiesToggle.hidden = YES;
	NSArray *amenities = self.hotelCompact.hotelProperty.amenities.amenity;
	if (amenities && amenities.count > 0) {
		NSMutableString *amenitiesString = [NSMutableString new];
		BOOL first = YES;
		NSUInteger numAmenitiesToShow = all ? amenities.count : MIN(DEFAULT_AMENITIES_COUNT, amenities.count);

		for (NSUInteger i = 0; i < numAmenitiesToShow; ++i) {
			Amenity *amenity = amenities[i];
			NSString *amenityName = amenity.name;
			if (amenityName) {
				if (first) {
					first = NO;
				}
				else {
					[amenitiesString appendString:@"\n"];
				}
				[amenitiesString appendFormat:@"• %@", amenityName];
			}
		}
		self.showAllAmenitiesToggle.hidden = amenities.count <= DEFAULT_AMENITIES_COUNT;
		
		if (all) {
			[self.amenitiesLabel setTextAnimated:amenitiesString];
			[UIView setAnimationsEnabled:NO];
			[self.showAllAmenitiesToggle setTitle:NSLocalizedString(@"Show fewer hotel amenities", @"") forState:UIControlStateNormal];
			[UIView setAnimationsEnabled:YES];
		} else {
			// don't animate when cutting the text down, as it looks jittery
			[self.amenitiesLabel setText:amenitiesString];
			[UIView setAnimationsEnabled:NO];
			[self.showAllAmenitiesToggle setTitle:NSLocalizedString(@"Show all hotel amenities", @"") forState:UIControlStateNormal];
			[UIView setAnimationsEnabled:YES];
		}
	}
	
}

- (void)configureContactInfo {
	if (self.hotelCompact.hotelProperty.propertyAddress.address) {
		self.addressLabel.text = self.hotelCompact.hotelProperty.propertyAddress.address;
	}
	
	if (self.hotelDetailsResult.hotelDetails.hotelProperty.telephoneNumber) {
		self.telephoneNumberLabel.text = self.hotelDetailsResult.hotelDetails.hotelProperty.telephoneNumber;
	}

	if (self.hotelDetailsResult.hotelDetails.hotelProperty.faxNumber) {
		self.faxNumberLabel.text = self.hotelDetailsResult.hotelDetails.hotelProperty.faxNumber;
	}
}

- (IBAction)telephoneTapped:(id)sender {
	NSString *telephoneNumber = self.hotelDetailsResult.hotelDetails.hotelProperty.telephoneNumber;
	if (telephoneNumber) {
		// strip all non-digits
		telephoneNumber = [[telephoneNumber componentsSeparatedByCharactersInSet:
		  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
						   componentsJoinedByString:@""];
		NSString *phoneNumber = [@"tel://" stringByAppendingString:telephoneNumber];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
	}
}

- (void)configureMap {
	if (self.mapView.delegate) {
		NSLog(@"map view delegate: %@, self: %@", self.mapView.delegate, self);
		
		GeoLocation *location = self.hotelCompact.hotelProperty.coordinateLocation;
		CLLocationCoordinate2D coord2D;
		MKPointAnnotation *newAnnotation = nil;
		if (location) {
			coord2D = location.coordinate2D;
			newAnnotation = [MKPointAnnotation new];
			newAnnotation.title = self.hotelCompact.hotelProperty.name;
			newAnnotation.coordinate = coord2D;
		}
		else {
			coord2D = self.searchData.location.coordinate;
		}
		
		MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(coord2D, 1000, 1000);
		self.mapView.visibleMapRect = [self mapRectForCoordinateRegion:mapRegion];
		
		[self.mapView removeAnnotations:self.mapView.annotations];
		if (newAnnotation) {
			[self.mapView addAnnotation:newAnnotation];
		}
		
		NSLog(@"map view annotations: %@", self.mapView.annotations);
	}
}

- (MKMapRect)mapRectForCoordinateRegion:(MKCoordinateRegion)region
{
	MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
																	  region.center.latitude + region.span.latitudeDelta / 2,
																	  region.center.longitude - region.span.longitudeDelta / 2));
	MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
																	  region.center.latitude - region.span.latitudeDelta / 2,
																	  region.center.longitude + region.span.longitudeDelta / 2));
	return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
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

- (IBAction)toggleShowAllAmenities:(id)sender {
	[self configureAmenities:!self.showingAllAmenities];
}

- (void)showActivityIndicator {
	[self.indicatorContainer.superview bringSubviewToFront:self.indicatorContainer];
	self.indicatorContainer.hidden = NO;
	[self.indicator startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideActivityIndicator {
	self.indicatorContainer.hidden = YES;
	[self.indicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)makeDetailRequest {
	[self showActivityIndicator];
	
	if (self.currentRequest) {
		[self.currentRequest cancel];
		self.currentRequest = nil;
	}

	__weak HotelDetailViewController *weakSelf = self;
	self.currentRequest = [HotelApi.sharedInstance getHotelDetails:self.hotelCompact.hotelId
								  searchData:self.searchData
									 success:
	 ^(HotelDetailsResult *hotelDetailsResult) {
		 if (weakSelf) {
			 [weakSelf hideActivityIndicator];
			 weakSelf.currentRequest = nil;

			 weakSelf.hotelDetailsResult = hotelDetailsResult;
			 [weakSelf configureView];
		 }
	 } failure:
	 ^(NSError *error) {
		 if (weakSelf) {
			 [weakSelf hideActivityIndicator];
			 weakSelf.currentRequest = nil;

			 [weakSelf showErrorMessage:NSLocalizedString(@"An error prevented us getting the full details for this hotel", @"")];
		 }
	 }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	static CGFloat originalNameContainerAlpha = -1.0;
	if (originalNameContainerAlpha == -1.0) {
		originalNameContainerAlpha = self.nameContainer.alpha;
	}
	static CGFloat originalImageViewHeight = -1.0;
	if (originalImageViewHeight == -1.0) {
		originalImageViewHeight = self.imageViewHeightConstraint.constant;
	}
	static CGFloat originalMapViewHeight = -1.0;
	if (originalMapViewHeight == -1.0) {
		originalMapViewHeight = self.mapViewHeightConstraint.constant;
	}
	static CGFloat originalMapViewTopOffset = -1.0;
	if (originalMapViewTopOffset == -1.0) {
		originalMapViewTopOffset = self.mapViewTopOffsetConstraint.constant;
	}
	
	// Parallax scroll the main image
	CGFloat scrollYOffset = scrollView.contentOffset.y;
	CGFloat newImageHeight = originalImageViewHeight - scrollYOffset;
	if (newImageHeight >= 0.0) {
		self.imageViewHeightConstraint.constant = newImageHeight;
		self.imageViewTopOffsetConstraint.constant = scrollYOffset;
		self.priceContainerTopOffsetConstraint.constant = scrollYOffset + newImageHeight;
	}
	else {
		self.priceContainerTopOffsetConstraint.constant = scrollYOffset;
	}
	
	// Fade out name label and move to navigation item title
	if (scrollYOffset >= 0) {
		CGFloat offsetBeforeNameInvisible = originalImageViewHeight * 0.75;
		CGFloat delta = MAX(0.0, offsetBeforeNameInvisible - scrollYOffset);
		self.nameContainer.alpha = originalNameContainerAlpha * delta / offsetBeforeNameInvisible;
		if (self.nameContainer.alpha < 0.3) {
			self.navigationItem.title = self.hotelNameLabel.text;
		}
		else {
			self.navigationItem.title = NSLocalizedString(@"Hotel Detail", @"");
		}
	} else {
		self.nameContainer.alpha = originalNameContainerAlpha;
		self.navigationItem.title = NSLocalizedString(@"Hotel Detail", @"");
	}
	
	// Parallax scroll map view - note that this could not be done by changing the height constraint,
	// as it caused the map pins to jitter. Instead, we change the top offset, but have the map
	// slightly larger than it needs to be, to allow for overscrolling.
	CGFloat maxScrollYOffset = self.scrollViewContents.frame.size.height - scrollView.frame.size.height;
	CGFloat scrollOffsetFromBottom = maxScrollYOffset - scrollYOffset;
	self.mapViewTopOffsetConstraint.constant = originalMapViewTopOffset - scrollOffsetFromBottom / 2.0;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	static NSString *reuseId = @"HotelDetailsMapViewAnnotation";
	
	MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
	if(!annotationView) {
		annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
		annotationView.image = [UIImage imageNamed:@"ic_mappin"];
	} else {
		annotationView.annotation = annotation;
	}
	
	annotationView.enabled = YES;
	annotationView.canShowCallout = YES;
	annotationView.selected = YES;
	
	return annotationView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowRates"]) {
		RatesTableViewController *ratesTableViewController = segue.destinationViewController;
		ratesTableViewController.searchData = self.searchData;
		ratesTableViewController.hotelCompact = self.hotelCompact;
		ratesTableViewController.hotelDetailsResult = self.hotelDetailsResult;
	} else if ([segue.identifier isEqualToString:@"ShowPhotos"]) {
		PhotoViewerViewController *photoViewerViewController = segue.destinationViewController;
		photoViewerViewController.hotelCompact = self.hotelCompact;
	}
}

@end
