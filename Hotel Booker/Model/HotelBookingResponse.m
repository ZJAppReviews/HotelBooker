//
//  HotelBookingResponse.m
//  Hotel Booker
//
//  Created by Matt Graham on 08/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelBookingResponse.h"

NSString *const kBaseClassUniversalRecord = @"universalRecord";

@implementation HotelBookingResponse

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
	return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	
	// This check serves to make sure that a non-NSDictionary object
	// passed into the model class doesn't break the parsing.
	if(self && [dict isKindOfClass:[NSDictionary class]]) {
		self.universalRecord = [UniversalRecord modelObjectWithDictionary:
								[dict objectForKey:kBaseClassUniversalRecord]];
		
	}
	
	return self;
	
}

@end
