//
//  GeoLocation.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class RKObjectMapping;

@interface GeoLocation : NSObject

@property NSString *latitude;
@property NSString *longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate2D;

+ (RKObjectMapping *)rkMapping;

@end
