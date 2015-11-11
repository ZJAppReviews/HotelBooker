//
//  Distance.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "Distance.h"

@implementation Distance

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[Distance class]];
		[mapping addAttributeMappingsFromDictionary:@{
													  @"value" : @"value",
													  @"direction" : @"direction",
													  @"units" : @"unitsString"
													  }];
	}
	
	return mapping;
}

- (DistanceUnits)units {
	return [self.unitsString.lowercaseString isEqualToString:@"mi"] ? DistanceUnitsMiles : DistanceUnitsKm;
}

- (NSString *)formattedValue {
	NSString *formatString = self.value < 10 ? @"%.1lf %@" : @"%.0lf %@";
	return [NSString stringWithFormat:formatString, self.value, self.formattedUnitsString];
}

- (NSString *)formattedUnitsString {
	return self.units == DistanceUnitsMiles ? NSLocalizedString(@"Miles", @"") : NSLocalizedString(@"km", @"");
}

@end
