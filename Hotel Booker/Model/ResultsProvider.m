//
//  ResultsProvider.m
//  Hotel Booker
//
//  Created by Matt Graham on 10/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "ResultsProvider.h"

@implementation ResultsProvider

+ (NSArray /* ResultsProvider */ *)allProviders {
	static NSMutableArray *allProviders = nil;
	
	if (!allProviders) {
		allProviders = [NSMutableArray new];
		for (NSString *code in self.class.nameLookup) {
			ResultsProvider *provider = [ResultsProvider new];
			provider.code = code;
			[allProviders addObject:provider];
		}
	}
	
	return allProviders;
}

+ (NSDictionary *)nameLookup {
	static NSDictionary *nameLookup = nil;
	
	if (!nameLookup) {
		nameLookup = @{
					   @"1G" : @"Galileo",
					   @"1V" : @"Apollo",
					   @"1J" : @"JAL"
					   };
	}
	
	return nameLookup;
}

- (NSString *)name {
	NSString *name = self.class.nameLookup[self.code];
	if (!name) {
		NSLog(@"Unknown Provider code: %@", self.code);
	}
	return name;
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
		return self.hash == ((ResultsProvider *)other).hash;
	}
}

- (NSUInteger)hash
{
	return self.code.hash;
}

@end
