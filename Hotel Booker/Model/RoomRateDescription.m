//
//  RoomRateDescription.m
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "RoomRateDescription.h"

@implementation RoomRateDescription

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[RoomRateDescription class]];
		[mapping addAttributeMappingsFromDictionary:@{
													  @"name" : @"name",
													  @"text" : @"textArray"
													  }];
	}
	return mapping;
}

- (NSString *)text {
	NSMutableString *result = [NSMutableString new];
	BOOL first = YES;
	for (NSString *text in self.textArray) {
		if (first) {
			first = NO;
		}
		else {
			[result appendString:@"\n"];
		}
		[result appendString:text];
	}
	if ([self.name isEqualToString:@"Description"]) {
		return result.capitalizedString;
	}
	return result;
}

@end
