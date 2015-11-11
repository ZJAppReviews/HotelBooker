//
//  LocationUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 20/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "LocationUtils.h"
#import <UIKit/UIKit.h>

@interface LocationUtils() <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property NSMutableArray /* LocationHandler */ *locationHandlers;

@end

@implementation LocationUtils

+ (instancetype)sharedInstance {
	static LocationUtils *instance = nil;
	@synchronized(self) {
		if (instance == nil)
			instance = [self new];
	}
	return instance;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		_locationHandlers = [NSMutableArray new];
	}
	return self;
}

- (void)getLocationWithCompletionHandler:(LocationHandler)handler {
	[self startGettingLocation];
	
	[self.locationHandlers addObject:handler];
}

- (void)startGettingLocation {
	if (!self.locationManager) {
		self.locationManager = [CLLocationManager new];
		self.locationManager.delegate = self;
		self.locationManager.distanceFilter = kCLDistanceFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		
		if (UIDevice.currentDevice.systemVersion.floatValue >= 8.0) {
			[self.locationManager requestWhenInUseAuthorization];
		}
		
		[self.locationManager startUpdatingLocation];
	}
}

- (void)stopGettingLocation {
	[self.locationHandlers removeAllObjects];
	[self.locationManager stopUpdatingLocation];
	self.locationManager= nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

	CLLocation *location = locations.lastObject;
	NSLog(@"Reporting location to %ld handlers: %@", (unsigned long)self.locationHandlers.count, location);

	for (LocationHandler handler in self.locationHandlers) {
		handler(location, nil);
	}
	
	[self stopGettingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Location Manager error: %@", error);

	NSLog(@"Reporting location ERROR to %ld handlers", (unsigned long)self.locationHandlers.count);
	
	for (LocationHandler handler in self.locationHandlers) {
		handler(nil, error);
	}
	
	[self stopGettingLocation];
}

@end
