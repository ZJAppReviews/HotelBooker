//
//  Amenity.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "Amenity.h"

@implementation Amenity

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[Amenity class]];
		[mapping addAttributeMappingsFromArray:@[
												 @"code"
												 ]];
	}
	return mapping;
}

+ (NSDictionary *)nameLookup {
	static NSMutableDictionary *nameLookup = nil;
	
	if (!nameLookup) {
		NSDate *startTime = [NSDate date];
		
		nameLookup = [NSMutableDictionary new];
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSString *filePath = [mainBundle pathForResource: @"HotelAmenities" ofType: @"csv"];
		NSError *error = nil;
		NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
		
		if (error) {
			NSLog(@"Failed to load amenities file: %@", error);
			return nameLookup;
		}
		
		NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		for (NSString *nameCodeString in lines) {
			NSArray *nameCodePair = [nameCodeString componentsSeparatedByString:@","];
			if (nameCodePair.count == 2) {
				nameLookup[nameCodePair[1]] = [nameCodePair[0] capitalizedString];
			}
		}
		
		NSLog(@"Time to create %ld amenities lookup: %lf", (unsigned long)nameLookup.count, [[NSDate date] timeIntervalSinceDate:startTime]);
	}
	
	return nameLookup;
}

- (NSString *)name {
	NSString *name = self.class.nameLookup[self.code];
	if (!name) {
		NSLog(@"Unknown Amenity code: %@", self.code);
	}
	return name;
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		Amenity *otherAmenity = (Amenity *)other;
		return self.hash == otherAmenity.hash;
	}
}

- (NSUInteger)hash {
	return self.code.hash;
}

@end
