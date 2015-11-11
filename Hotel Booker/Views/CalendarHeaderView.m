//
//  CalendarHeaderView.m
//  Hotel Booker
//
//  Created by Matt Graham on 13/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "CalendarHeaderView.h"
#import "NSDate+DateFormat.h"

@implementation CalendarHeaderView

- (void)setDate:(NSDate *)date {
	_date = date;
	
	if (date) {
		self.monthLabel.text = [date formatMonthYear];
	}
	else {
		self.monthLabel.text = nil;
	}
}

@end
