//
//  NSDate+DateUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 14/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "NSDate+DateUtils.h"

@implementation NSDate (DateUtils)

+ (NSCalendar *)calendar {
	static NSCalendar *calendar = nil;
	
	if (!calendar) {
		calendar = [NSCalendar currentCalendar];
		calendar.firstWeekday = GregorianWeekDayMonday;
	}
	
	return calendar;
}

- (BOOL)isSameDayAs:(NSDate *)otherDate {
	if (!otherDate) {
		return NO;
	}
	
	NSDateComponents *components1 = [self getYearMonthDayComponents];
	NSDateComponents *components2 = [otherDate getYearMonthDayComponents];
	
	return (components1.day == components2.day &&
			components1.month == components2.month &&
			components1.year == components2.year);
}

- (BOOL)isEarlierDayThan:(NSDate *)otherDate {
	if (!otherDate) {
		return NO;
	}

	NSDateComponents *components1 = [self getYearMonthDayComponents];
	NSDateComponents *components2 = [otherDate getYearMonthDayComponents];
	
	return (components1.year < components2.year ||
			(components1.year == components2.year &&
			 (components1.month < components2.month ||
			  (components1.month == components2.month &&
			   components1.day < components2.day))));
}

- (BOOL)isLaterDayThan:(NSDate *)otherDate {
	if (!otherDate) {
		return NO;
	}

	NSDateComponents *components1 = [self getYearMonthDayComponents];
	NSDateComponents *components2 = [otherDate getYearMonthDayComponents];
	
	return components1.year > components2.year ||
			(components1.year == components2.year &&
			 (components1.month > components2.month ||
			  (components1.month == components2.month &&
			   components1.day > components2.day)));
}

- (BOOL)isDayBefore:(NSDate *)otherDate {
	if (!otherDate) {
		return NO;
	}
	NSDate *dayBeforeOtherDate = [otherDate dateByAddingDays:-1];
	return [self isSameDayAs:dayBeforeOtherDate];
}

- (BOOL)isDayAfter:(NSDate *)otherDate {
	if (!otherDate) {
		return NO;
	}
	NSDate *dayAfterOtherDate = [otherDate dateByAddingDays:1];
	return [self isSameDayAs:dayAfterOtherDate];
}

- (BOOL)isEarlierMonthThan:(NSDate *)otherDate {
	if (!otherDate) {
		return NO;
	}
	
	NSDateComponents *components1 = [self getYearMonthDayComponents];
	NSDateComponents *components2 = [otherDate getYearMonthDayComponents];
	
	return (components1.year < components2.year ||
			(components1.year == components2.year &&
			 components1.month < components2.month));
}

- (BOOL)isBetweenDatesInclusive:(NSDate *)date1 date2:(NSDate *)date2 {
	if (!date1 || !date2) {
		return NO;
	}
	
	return [self compare:date1] != NSOrderedAscending && [self compare:date2] != NSOrderedDescending;
}
														  
- (BOOL)isBetweenDatesExclusive:(NSDate *)date1 date2:(NSDate *)date2 {
	if (!date1 || !date2) {
		return NO;
	}
	
	return [self compare:date1] == NSOrderedDescending && [self compare:date2] == NSOrderedAscending;	
}

- (NSDateComponents *)getYearMonthDayComponents {
	return [self.class.calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
												fromDate:self];
}

- (NSInteger)daysInMonth {
	NSRange range = [self.class.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
	if (range.location == NSNotFound) {
		[NSException raise:@"Couldn't determine no. of days in month: " format:@"%@", self];
	}
	return range.length;
}

- (NSInteger)weeksInMonth {
	NSCalendarUnit weekUnit = NSCalendarUnitWeekOfMonth;
	if (UIDevice.currentDevice.systemVersion.floatValue < 8.0) {
		// NSCalendarUnitWeekOfMonth does not work on iOS7
		weekUnit = NSWeekCalendarUnit;
	}
	NSRange range = [self.class.calendar rangeOfUnit:weekUnit inUnit:NSCalendarUnitMonth forDate:self];

	if (range.location == NSNotFound) {
		[NSException raise:@"Couldn't determine no. of weeks in month: " format:@"%@", self];
	}
	return range.length;
	return 4;
}

- (NSInteger)weekDayRelativeTo:(GregorianWeekDay)firstWeekDay {
	NSInteger weekDay = [self.class.calendar components:NSCalendarUnitWeekday
											   fromDate:self].weekday;
	NSInteger offset = weekDay - firstWeekDay;
	if (offset < 0) {
		offset += 7;
	}
	return (offset % 7) + 1;
}

- (NSDate *)dateByAddingMonths:(NSInteger)numMonths {
	NSDateComponents *components = [NSDateComponents new];
	components.month = numMonths;
	return [self.class.calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)numDays {
	NSDateComponents *components = [NSDateComponents new];
	components.day = numDays;
	return [self.class.calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)firstDayOfMonth {
	NSCalendar *calendar = self.class.calendar;
	NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitEra|NSCalendarUnitTimeZone
											   fromDate:self];
	components.day = 1;
	return [calendar dateFromComponents:components];
}

- (NSInteger)daysSince:(NSDate *)otherDate {
	if (!otherDate) {
		return 0;
	}
	NSDateComponents *components = [self.class.calendar components:NSCalendarUnitDay fromDate:otherDate toDate:self options:NSCalendarWrapComponents];
	return components.day;
}

@end
