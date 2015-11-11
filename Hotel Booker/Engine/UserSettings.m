//
//  UserSettings.m
//  Hotel Booker
//
//  Created by Matt Graham on 10/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "UserSettings.h"

static NSString * const USER_SETTINGS_KEY_PROVIDER_CODES =	@"USER_SETTINGS_KEY_PROVIDER_CODES";
#define USER_SETTINGS_DEFAULT_PROVIDER_CODES				@[@"1V"]

static NSString * const USER_SETTINGS_KEY_RESULTS_ENVIRONMENT =	@"USER_SETTINGS_KEY_RESULTS_ENVIRONMENT";
static NSString * const USER_SETTINGS_DEFAULT_RESULTS_ENVIRONMENT =	@"PRE-PROD";

@implementation UserSettings

+ (instancetype)sharedInstance {
	static UserSettings *instance = nil;
	@synchronized(self) {
		if (instance == nil)
			instance = [self new];
	}
	return instance;
}

- (NSArray *)resultsProviders {
	NSArray *providerCodes = self.resultsProviderCodes;
	
	NSMutableArray *providers = [NSMutableArray new];
	for (NSString *code in providerCodes) {
		ResultsProvider *provider = [ResultsProvider new];
		provider.code = code;
		[providers addObject:provider];
	}
	return providers;
}

-(NSArray *)resultsProviderCodes {
	NSArray *providerCodes = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_SETTINGS_KEY_PROVIDER_CODES];
	if (!providerCodes) {
		// default value
		providerCodes = USER_SETTINGS_DEFAULT_PROVIDER_CODES;
	}
	return providerCodes;
}

- (void)setResultsProviders:(NSArray *)resultsProviders {
	NSMutableArray *codes = nil;
	if (resultsProviders) {
		codes = [NSMutableArray new];
		for (ResultsProvider *provider in resultsProviders) {
			[codes addObject:provider.code];
		}
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:codes forKey:USER_SETTINGS_KEY_PROVIDER_CODES];
}

- (ResultsEnvironment *)resultsEnvironment {
	NSString *code = [[NSUserDefaults standardUserDefaults] stringForKey:USER_SETTINGS_KEY_RESULTS_ENVIRONMENT];
	if (!code) {
		code = USER_SETTINGS_DEFAULT_RESULTS_ENVIRONMENT;
	}
	ResultsEnvironment *resultsEnvironment = [ResultsEnvironment environmentsWithCode:code];
	return resultsEnvironment;
}

- (void)setResultsEnvironment:(ResultsEnvironment *)resultsEnvironment {
	[[NSUserDefaults standardUserDefaults] setObject:resultsEnvironment.code forKey:USER_SETTINGS_KEY_RESULTS_ENVIRONMENT];
}

@end
