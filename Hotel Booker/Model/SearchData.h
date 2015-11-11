//
//  SearchData.h
//  Hotel Booker
//
//  Created by Matt Graham on 15/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface SearchData : NSObject

@property CLLocation* location;
@property NSInteger numAdults;
@property NSDate *checkInDate;
@property NSDate *checkOutDate;
@property (readonly) NSString *checkInDateString;
@property (readonly) NSString *checkOutDateString;

- (NSDictionary *)queryParamsForSearch:(BOOL)forSearch branch:(NSString *)targetBranch;

@end
