//
//  HotelReservation.m
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelReservation.h"

NSString *const kHotelReservationBookingConfirmation = @"bookingConfirmation";
NSString *const kHotelReservationProviderReservationInfoRef = @"providerReservationInfoRef";

@implementation HotelReservation

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
	return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	
	if(self && [dict isKindOfClass:[NSDictionary class]]) {
		self.bookingConfirmation = [self objectOrNilForKey:kHotelReservationBookingConfirmation fromDictionary:dict];
		self.providerReservationInfoRef = [self objectOrNilForKey:kHotelReservationProviderReservationInfoRef fromDictionary:dict];
		
	}
	
	return self;
	
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
	id object = [dict objectForKey:aKey];
	return [object isEqual:[NSNull null]] ? nil : object;
}

@end
