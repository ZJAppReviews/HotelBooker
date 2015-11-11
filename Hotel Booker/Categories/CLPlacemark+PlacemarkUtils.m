//
//  CLPlacemark+PlacemarkUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 20/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "CLPlacemark+PlacemarkUtils.h"

@implementation CLPlacemark (PlacemarkUtils)

- (NSString *)description {
	// ABCreateStringWithAddressDictionary does not always give a full address, so we cannot use it
	NSArray *formattedAddressLines = self.addressDictionary[@"FormattedAddressLines"];
	NSString *result = [formattedAddressLines componentsJoinedByString:@", "];
	
	if (self.country) {
		if ([result isEqualToString:self.country]) {
			return result;
		}
	
		// remove country string (and its preceding comma), as we add it in subdescription
		// assume country will be at the end
		NSRange rangeCountry = [result rangeOfString:[@", " stringByAppendingString:self.country]];
		if (rangeCountry.location != NSNotFound) {
			result = [result substringToIndex:rangeCountry.location];
		}
	}
	return result;
}

- (NSString *)subDescription {
	if (self.country && ![self.country isEqualToString:self.description]) {
		return [NSString stringWithFormat:@"%@", self.country];
	}
	else {
		return nil;
	}
}

#pragma mark - isEqual and hash to ensure that entries that appear to be the same aren't duplicated

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![other isKindOfClass:self.class]) {
		return NO;
	} else {
		CLPlacemark *otherPlacemark = (CLPlacemark *)other;
		return self.hash == otherPlacemark.hash;
	}
}

- (NSUInteger)hash {
	return self.description.hash + self.subDescription.hash;
}

@end
