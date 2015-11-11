//
//  Distance.h
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef NS_ENUM(NSUInteger, DistanceUnits) {
	DistanceUnitsMiles,
	DistanceUnitsKm
};

@interface Distance : NSObject

@property double value;
@property NSString *direction;
@property NSString *unitsString;
@property (readonly) DistanceUnits units;

+ (RKObjectMapping *)rkMapping;

- (NSString *)formattedValue;
- (NSString *)formattedUnitsString;

@end
