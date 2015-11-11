//
// Amenity.h
// HotelBooker
//
// Created by Matt Grahamon 26/05/2015.
// Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Amenity : NSObject

@property NSString *code;
@property (readonly) NSString *name;

+ (RKObjectMapping*)rkMapping;

@end
