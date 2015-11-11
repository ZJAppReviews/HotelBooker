//
//  UniversalRecord.m
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "UniversalRecord.h"

NSString *const kUniversalRecordLocatorCode = @"locatorCode";
NSString *const kUniversalRecordHotelReservation = @"hotelReservation";

@implementation UniversalRecord

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
	return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	
	if(self && [dict isKindOfClass:[NSDictionary class]]) {
		self.locatorCode = [self objectOrNilForKey:kUniversalRecordLocatorCode fromDictionary:dict];
		self.hotelReservation = [HotelReservation modelObjectWithDictionary:[dict objectForKey:kUniversalRecordHotelReservation]];
		
	}
	
	return self;
	
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
	id object = [dict objectForKey:aKey];
	return [object isEqual:[NSNull null]] ? nil : object;
}

@end
