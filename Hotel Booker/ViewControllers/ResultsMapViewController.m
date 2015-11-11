//
//  ResultsMapViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 15/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "ResultsMapViewController.h"
#import "HotelCompact.h"
#import "HotelDetailViewController.h"

@interface ResultsMapAnnotation : MKPointAnnotation

@property (nonatomic) HotelCompact *hotel;

@end

@implementation ResultsMapAnnotation

@end

@interface ResultsMapViewController ()

@property (nonatomic) HotelCompact *selectedHotel;

@end

@implementation ResultsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self populate];
}

- (void)setHotels:(NSArray *)hotels {
	_hotels = hotels;
	[self populate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populate {
	if (self.hotels && self.hotels.count > 0) {
		
		[self.mapView removeAnnotations:self.mapView.annotations];
		[self.mapView removeOverlays:self.mapView.overlays];
		
		MKMapRect zoomRect = MKMapRectNull;
		double mapPointsPerMeter = 0.0;

		for (HotelCompact *hotel in self.hotels) {
			GeoLocation *location = hotel.hotelProperty.coordinateLocation;
			
			if (location) {
				if (mapPointsPerMeter == 0.0) {
					mapPointsPerMeter = MKMapPointsPerMeterAtLatitude(location.coordinate2D.latitude);
				}
				
				ResultsMapAnnotation *newAnnotation = [ResultsMapAnnotation new];
				newAnnotation.title = hotel.hotelProperty.name;
				newAnnotation.coordinate = location.coordinate2D;
				newAnnotation.hotel = hotel;
				[self.mapView addAnnotation:newAnnotation];
				
				MKMapPoint annotationPoint = MKMapPointForCoordinate(newAnnotation.coordinate);
				MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 100 * mapPointsPerMeter, 100 * mapPointsPerMeter);
				zoomRect = MKMapRectUnion(zoomRect, pointRect);
			}
		}
		
		CGFloat edgeInset = 150;
		if (UIDevice.currentDevice.systemVersion.floatValue < 8.0) {
			edgeInset = 100;
		}
		[self.mapView setVisibleMapRect:zoomRect
							edgePadding:UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset)
							   animated:YES];
	}
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	static NSString *reuseId = @"ResultsMapViewAnnotation";
	
	MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
	if(!annotationView) {
		annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
		annotationView.image = [UIImage imageNamed:@"ic_mappin"];

		UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		// even though we request DetailDisclosure type, the info icon is used, so we need to override
		button.tintColor = [UIColor blackColor];
		[button setImage:[UIImage imageNamed:@"ic_chevronmap"] forState:UIControlStateNormal];
		annotationView.rightCalloutAccessoryView = button;
		
	} else {
		annotationView.annotation = annotation;
	}
	
	annotationView.enabled = YES;
	annotationView.canShowCallout = YES;
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	ResultsMapAnnotation *annotation = view.annotation;
	self.selectedHotel = annotation.hotel;
	NSLog(@"Hotel selected: %@", annotation.hotel.hotelProperty.name);
	[self performSegueWithIdentifier:@"ShowDetail" sender:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowDetail"]) {
		HotelDetailViewController *hotelDetailViewController = segue.destinationViewController;
		hotelDetailViewController.searchData = self.searchData;
		hotelDetailViewController.hotelCompact = self.selectedHotel;
	}
}

@end
