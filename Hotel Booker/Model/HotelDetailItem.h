//
//  HotelDetailItem.h
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface HotelDetailItem : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *text;

+ (RKObjectMapping *)rkMapping;

@end
