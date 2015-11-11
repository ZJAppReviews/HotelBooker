//
//  ResultsEnvironment.h
//  Hotel Booker
//
//  Created by Matt Graham on 07/08/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsEnvironment : NSObject

+ (NSArray /* ResultsEnvironment */ *)allEnvironments;
+ (ResultsEnvironment *)environmentsWithCode:(NSString *)code;

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) BOOL allowsBooking;
@property (nonatomic) NSString *targetBranch;
@property (nonatomic) NSString *port;

@end
