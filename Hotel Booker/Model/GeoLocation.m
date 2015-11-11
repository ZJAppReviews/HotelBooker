//
//  GeoLocation.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "GeoLocation.h"
#import <RestKit/RestKit.h>

@implementation GeoLocation

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[GeoLocation class]];
		[mapping addAttributeMappingsFromArray:@[
												 @"latitude",
												 @"longitude"
												 ]];
	}
	return mapping;
}

- (CLLocationCoordinate2D)coordinate2D {
	return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

@end
