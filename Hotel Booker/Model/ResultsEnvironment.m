//
//  ResultsEnvironment.m
//  Hotel Booker
//
//  Created by Matt Graham on 07/08/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "ResultsEnvironment.h"
#import "Config.h"

@implementation ResultsEnvironment

+ (NSArray /* ResultsEnvironment */ *)allEnvironments {
	static NSMutableArray *allEnvironments = nil;
	
	if (!allEnvironments) {
		allEnvironments = [NSMutableArray new];
		for (NSString *code in @[@"PRE-PROD", @"PROD"]) {
			ResultsEnvironment *environment = [ResultsEnvironment environmentsWithCode:code];
			[allEnvironments addObject:environment];
		}
	}
	
	return allEnvironments;
}

+ (ResultsEnvironment *)environmentsWithCode:(NSString *)code {
	ResultsEnvironment *resultsEnvironment = nil;
	
	if ([code isEqualToString:@"PROD"]) {
		resultsEnvironment = [ResultsEnvironment new];
		resultsEnvironment.code = code;
		resultsEnvironment.name = NSLocalizedString(@"Production", @"");
		resultsEnvironment.username = BASIC_AUTH_PROD_USERNAME;
		resultsEnvironment.password = BASIC_AUTH_PROD_PASSWORD;
		resultsEnvironment.allowsBooking = NO;
        resultsEnvironment.targetBranch = PROD_TARGET_BRANCH;
        resultsEnvironment.port = PROD_PORT;
	}
	else if([code isEqualToString:@"PRE-PROD"]) {
		resultsEnvironment = [ResultsEnvironment new];
		resultsEnvironment.code = code;
		resultsEnvironment.name = NSLocalizedString(@"Pre-production", @"");
		resultsEnvironment.username = BASIC_AUTH_PRE_PROD_USERNAME;
		resultsEnvironment.password = BASIC_AUTH_PRE_PROD_PASSWORD;
		resultsEnvironment.allowsBooking = YES;
        resultsEnvironment.targetBranch = PRE_PROD_TARGET_BRANCH;
        resultsEnvironment.port = PRE_PROD_PORT;
	}
	else {
		NSLog(@"Unknown Environment code: %@", code);
	}
	
	return resultsEnvironment;
}

- (NSString *)description {
	return self.name;
}

- (BOOL)isEqual:(id)other
{
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		return self.hash == ((ResultsEnvironment *)other).hash;
	}
}

- (NSUInteger)hash
{
	return self.code.hash;
}

@end
