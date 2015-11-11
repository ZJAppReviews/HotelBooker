//
//  HotelRating.h
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface HotelRating : NSObject

@property NSString *rating;

+ (RKObjectMapping *)rkMapping;

@end
