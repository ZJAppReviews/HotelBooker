//
//  NSDate+DateFormat.h
//  Hotel Booker
//
//  Created by Matt Graham on 15/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides date-formatting functions.
 */
@interface NSDate (DateFormat)

- (NSString *)formatDayOfMonth;
- (NSString *)formatDayOfWeek;
- (NSString *)formatShortDayOfWeek;
- (NSString *)formatDayMonth;
- (NSString *)formatMonthYear;
- (NSString *)formatDayMonthYear;
- (NSString *)formatApi;
+ (NSDate *)parseApiDateString:(NSString *)dateString;
- (NSString *)formatApiYearMonth;
+ (NSDate *)parseCreditCardExpiryDateString:(NSString *)dateString;

@end
