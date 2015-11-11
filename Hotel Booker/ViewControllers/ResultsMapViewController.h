//
//  ResultsMapViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 15/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "SearchData.h"

/**
 * The view controller for the map screen that is accessible from the hotel list screen. This allows the user to see 
 * their search results plotted on a map.
 */
@interface ResultsMapViewController : BaseViewController <MKMapViewDelegate>

@property (nonatomic) SearchData *searchData;
@property (nonatomic) NSArray* hotels;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
