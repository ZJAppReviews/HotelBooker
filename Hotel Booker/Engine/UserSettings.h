//
//  UserSettings.h
//  Hotel Booker
//
//  Created by Matt Graham on 10/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultsProvider.h"
#import "ResultsEnvironment.h"

@interface UserSettings : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) NSArray /* ResultsProvider */*resultsProviders;
@property (nonatomic, readonly) NSArray /* NSString */*resultsProviderCodes;

@property (nonatomic) ResultsEnvironment *resultsEnvironment;

@end
