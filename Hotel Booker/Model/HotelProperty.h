//
//  HotelProperty.h
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "PropertyAddress.h"
#import "GeoLocation.h"
#import "Distance.h"
#import "HotelRating.h"
#import "Amenities.h"
#import "PhoneNumber.h"

@interface HotelProperty : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) PropertyAddress *propertyAddress;
@property (nonatomic) GeoLocation *coordinateLocation;
@property (nonatomic) NSString *availability;
@property (nonatomic) Distance *distance;
@property (nonatomic) NSArray /* HotelRating */ *hotelRatings;
@property (nonatomic) Amenities *amenities;
@property (nonatomic) BOOL featuredProperty;
@property (nonatomic) NSArray /* PhoneNumber */ *phoneNumbers;

@property (nonatomic, readonly) HotelRating *hotelRating;
@property (nonatomic, readonly) NSString *telephoneNumber;
@property (nonatomic, readonly) NSString *faxNumber;

- (NSString *)phoneNumberWithType:(NSString *)type;

+ (RKObjectMapping *)rkMapping;

@end
