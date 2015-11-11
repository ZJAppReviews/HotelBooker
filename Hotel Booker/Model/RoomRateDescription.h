//
//  RoomRateDescription.h
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RoomRateDescription : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray /* NSString */ *textArray;
@property (nonatomic, readonly) NSString *text;

+ (RKObjectMapping *)rkMapping;

@end
