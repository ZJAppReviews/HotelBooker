//
//  SearchData.m
//  Hotel Booker
//
//  Created by Matt Graham on 15/01/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "SearchData.h"
#import "NSDate+DateFormat.h"
#import "Config.h"
#import "UserSettings.h"

@implementation SearchData

- (NSString *)checkInDateString {
	return [self.checkInDate formatApi];
}

- (NSString *)checkOutDateString {
	return [self.checkOutDate formatApi];
}

- (NSDictionary *)queryParamsForSearch:(BOOL)forSearch branch:(NSString *)targetBranch {
	NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithDictionary:@{@"targetBranch" : targetBranch,
																					   @"adults": @(self.numAdults),
																					   @"in" : self.checkInDateString,
																					   @"out" : self.checkOutDateString}];
	if (forSearch) {
		queryParams[@"lat"] = [NSString stringWithFormat:@"%.6lf", self.location.coordinate.latitude];
		queryParams[@"long"] = [NSString stringWithFormat:@"%.6lf", self.location.coordinate.longitude];
		queryParams[@"providers"] = [UserSettings.sharedInstance.resultsProviderCodes componentsJoinedByString:@","];
	}
	
	return queryParams;
}


@end
