//
//  ResultsProvider.h
//  Hotel Booker
//
//  Created by Matt Graham on 10/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsProvider : NSObject

+ (NSArray /* ResultsProvider */ *)allProviders;

@property NSString *code;
@property (readonly) NSString *name;

@end
