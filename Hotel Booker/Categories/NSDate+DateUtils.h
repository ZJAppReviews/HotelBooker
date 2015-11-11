//
//  NSDate+DateUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 14/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GregorianWeekDay) {
	GregorianWeekDaySunday = 1,
	GregorianWeekDayMonday,
	GregorianWeekDayTuesday,
	GregorianWeekDayWednesday,
	GregorianWeekDayThursday,
	GregorianWeekDayFriday,
	GregorianWeekDaySaturday
};

/**
 * Provides date-related utilities.
 */
@interface NSDate (DateUtils)

- (BOOL)isSameDayAs:(NSDate *)otherDate;
- (BOOL)isEarlierDayThan:(NSDate *)otherDate;
- (BOOL)isLaterDayThan:(NSDate *)otherDate;
- (BOOL)isDayBefore:(NSDate *)otherDate;
- (BOOL)isDayAfter:(NSDate *)otherDate;
- (BOOL)isEarlierMonthThan:(NSDate *)otherDate;
- (BOOL)isBetweenDatesInclusive:(NSDate *)date1 date2:(NSDate *)date2;
- (BOOL)isBetweenDatesExclusive:(NSDate *)date1 date2:(NSDate *)date2;
- (NSDateComponents *)getYearMonthDayComponents;
- (NSInteger)daysInMonth;
- (NSInteger)weeksInMonth;
- (NSInteger)weekDayRelativeTo:(GregorianWeekDay)firstWeekDay;
- (NSDate *)dateByAddingMonths:(NSInteger)numMonths;
- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)firstDayOfMonth;
- (NSInteger)daysSince:(NSDate *)otherDate;

@end
