//
//  Amenities.h
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Amenity.h"

@interface Amenities : NSObject

@property NSArray /* Amenity */ *amenity;

+ (RKObjectMapping *)rkMapping;

@end
