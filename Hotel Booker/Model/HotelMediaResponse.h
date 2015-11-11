//
//  HotelMediaResponse.h
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "MediaItems.h"

@interface HotelMediaResponse : NSObject

@property (nonatomic) MediaItems *mediaItemsContainer;

+ (RKObjectMapping *)rkMapping;

@end
