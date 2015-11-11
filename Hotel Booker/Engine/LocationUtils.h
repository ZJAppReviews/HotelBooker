//
//  LocationUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 20/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationHandler)(CLLocation *location, NSError *error);

/**
 * Provides location-related utility functions
 */
@interface LocationUtils : NSObject

+ (instancetype)sharedInstance;

/**
 * Provides a simplified way to get the device's current location, delivered via a block handler function
 */
- (void)getLocationWithCompletionHandler:(LocationHandler)handler;

@end
