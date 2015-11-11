//
//  NSDate+DateFormat.m
//  Hotel Booker
//
//  Created by Matt Graham on 15/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "NSDate+DateFormat.h"

@implementation NSDate (DateFormat)

+ (NSDateFormatter *)createDateFormatter {
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.locale = [NSLocale currentLocale];
	dateFormatter.timeZone = [NSTimeZone localTimeZone];
	return dateFormatter;
}

+ (NSDateFormatter *)dayOfMonthFormatter {
	static NSDateFormatter *dayOfMonthFormatter = nil;
	
	if (!dayOfMonthFormatter) {
		dayOfMonthFormatter = [self createDateFormatter];
		[dayOfMonthFormatter setDateFormat:@"d"];
	}
	
	return dayOfMonthFormatter;
}

- (NSString *)formatDayOfMonth {
	return [self.class.dayOfMonthFormatter stringFromDate:self];
}

+ (NSDateFormatter *)dayOfWeekFormatter {
	static NSDateFormatter *dayOfWeekFormatter = nil;
	
	if (!dayOfWeekFormatter) {
		dayOfWeekFormatter = [self createDateFormatter];
		[dayOfWeekFormatter setDateFormat:@"EEEE"];
	}
	
	return dayOfWeekFormatter;
}

- (NSString *)formatDayOfWeek {
	return [self.class.dayOfWeekFormatter stringFromDate:self];
}

+ (NSDateFormatter *)shortDayOfWeekFormatter {
	static NSDateFormatter *shortDayOfWeekFormatter = nil;
	
	if (!shortDayOfWeekFormatter) {
		shortDayOfWeekFormatter = [self createDateFormatter];
		[shortDayOfWeekFormatter setDateFormat:@"EEE"];
	}
	
	return shortDayOfWeekFormatter;
}

- (NSString *)formatShortDayOfWeek {
	return [self.class.shortDayOfWeekFormatter stringFromDate:self];
}

+ (NSDateFormatter *)dayMonthFormatter {
	static NSDateFormatter *dayMonthFormatter = nil;
	
	if (!dayMonthFormatter) {
		dayMonthFormatter = [self createDateFormatter];
		[dayMonthFormatter setDateFormat:@"MMM d"];
	}
	
	return dayMonthFormatter;
}

- (NSString *)formatDayMonth {
	return [self.class.dayMonthFormatter stringFromDate:self];
}

+ (NSDateFormatter *)monthYearFormatter {
	static NSDateFormatter *monthYearFormatter = nil;
	
	if (!monthYearFormatter) {
		monthYearFormatter = [self createDateFormatter];
		[monthYearFormatter setDateFormat:@"MMMM yyyy"];
	}
	
	return monthYearFormatter;
}

- (NSString *)formatMonthYear {
	return [self.class.monthYearFormatter stringFromDate:self];
}

+ (NSDateFormatter *)dayMonthYearFormatter {
	static NSDateFormatter *dayMonthYearFormatter = nil;
	
	if (!dayMonthYearFormatter) {
		dayMonthYearFormatter = [self createDateFormatter];
		dayMonthYearFormatter.dateStyle = NSDateFormatterMediumStyle;
	}
	
	return dayMonthYearFormatter;
}

- (NSString *)formatDayMonthYear {
	return [self.class.dayMonthYearFormatter stringFromDate:self];
}

+ (NSDateFormatter *)apiFormatter {
	static NSDateFormatter *apiFormatter = nil;
 
	if (!apiFormatter) {
		apiFormatter = [self createDateFormatter];
		[apiFormatter setDateFormat:@"yyyy-MM-dd"];
	}
	
	return apiFormatter;
}

- (NSString *)formatApi {
	return [self.class.apiFormatter stringFromDate:self];
}

+ (NSDate *)parseApiDateString:(NSString *)dateString{
	return [self.apiFormatter dateFromString:dateString];
}

+ (NSDateFormatter *)apiYearMonthFormatter {
	static NSDateFormatter *apiYearMonthFormatter = nil;
 
	if (!apiYearMonthFormatter) {
		apiYearMonthFormatter = [self createDateFormatter];
		[apiYearMonthFormatter setDateFormat:@"yyyy-MM"];
	}
	
	return apiYearMonthFormatter;
}

- (NSString *)formatApiYearMonth {
	return [self.class.apiYearMonthFormatter stringFromDate:self];
}

+ (NSDateFormatter *)creditCardExpiryFormatter {
	static NSDateFormatter *creditCardExpiryFormatter = nil;
 
	if (!creditCardExpiryFormatter) {
		creditCardExpiryFormatter = [self createDateFormatter];
		[creditCardExpiryFormatter setDateFormat:@"MMyy"];
	}
	
	return creditCardExpiryFormatter;
}

+ (NSDate *)parseCreditCardExpiryDateString:(NSString *)dateString {
	if (dateString == nil || dateString.length == 0) {
		return nil;
	}
	return [self.creditCardExpiryFormatter dateFromString:dateString];
}



@end
