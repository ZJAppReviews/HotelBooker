//
//  HotelRateDetail.m
//  Hotel Booker
//
//  Created by Matt Graham on 04/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "HotelRateDetail.h"
#import "NSDate+DateUtils.h"

@implementation HotelRateDetail

+ (RKObjectMapping *)rkMapping {
	static RKObjectMapping *mapping = nil;
	
	if (!mapping) {
		mapping = [RKObjectMapping mappingForClass:[HotelRateDetail class]];
		
		[mapping addAttributeMappingsFromArray:@[
												 @"ratePlanType",
												 @"rateCategory"
												 ]];
		[mapping addAttributeMappingsFromDictionary:@{
													  @"total" : @"totalString" ,
													  @"tax" : @"taxString",
													  @"base" : @"baseString"
													  }];
		
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"roomRateDescription"
																				toKeyPath:@"roomRateDescriptions"
																			  withMapping:RoomRateDescription.rkMapping]];
		
		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hotelRateByDate"
																				toKeyPath:@"hotelRatesByDate"
																			  withMapping:HotelRateByDate.rkMapping]];

		[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"guaranteeInfo"
																				toKeyPath:@"guaranteeInfo"
																			  withMapping:GuaranteeInfo.rkMapping]];
	}
	return mapping;
}

- (CurrencyAmount *)total {
	return [CurrencyAmount amountWithString:self.totalString];
}

- (CurrencyAmount *)tax {
	return [CurrencyAmount amountWithString:self.taxString];
}

- (CurrencyAmount *)baseAmount {
	return [CurrencyAmount amountWithString:self.baseString];
}

/** Add the names of any RoomRateDescriptions to this that shoulde be filtered out */
+ (NSArray /* NSString */*)roomRateDescriptionNameBlackList {
	return @[@"Rate Change Indicator"
			 ];
}

- (NSString *)rateDescription {
	return [self roomRateDescriptionValueWithName:@"Description"];
}

- (NSString *)roomRateDescriptionValueWithName:(NSString *)name {
	for (RoomRateDescription *roomRateDescription in self.roomRateDescriptions) {
		if ([roomRateDescription.name isEqualToString:name]) {
			return roomRateDescription.text;
		}
	}
	return nil;
}

- (CurrencyAmount *)indicativeCost {
	HotelRateByDate *indicativeRate = self.hotelRatesByDate.firstObject;
	return indicativeRate.baseAmount;
}

- (NSArray /* RoomRateDescription */ *)getFilteredRoomRateDescriptions {
	NSIndexSet *indexes = [self.roomRateDescriptions indexesOfObjectsPassingTest:
	^BOOL(RoomRateDescription *roomRateDescription, NSUInteger idx, BOOL *stop) {
		return [self filterRoomRateDescription:roomRateDescription];
	}];
	return [self.roomRateDescriptions objectsAtIndexes:indexes];
}

- (BOOL)filterRoomRateDescription:(RoomRateDescription *)roomRateDescription {
	return (roomRateDescription.text && roomRateDescription.text.length > 0) &&
			(roomRateDescription.name && roomRateDescription.name.length > 0) &&
			([self.class.roomRateDescriptionNameBlackList indexOfObject:roomRateDescription.name] == NSNotFound);
}

- (HotelRateByDate *)rateForDate:(NSDate *)date {
	for (HotelRateByDate *rateByDate in self.hotelRatesByDate) {
		if ([rateByDate isValidForDate:date]) {
			return rateByDate;
		}
	}
	return nil;
}

@end
