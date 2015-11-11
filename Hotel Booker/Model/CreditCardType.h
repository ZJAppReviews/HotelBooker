//
//  CreditCardType.h
//  Hotel Booker
//
//  Created by Matt Graham on 26/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CreditCardTypeOption) {
	CreditCardTypeOptionVisa,
	CreditCardTypeOptionMastercard,
	CreditCardTypeOptionAmericanExpress,
};

@interface CreditCardType : NSObject

+ (NSArray *)allTypes;

- (instancetype)initWithType:(CreditCardTypeOption)type;

@property (nonatomic) CreditCardTypeOption type;
@property (nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) NSString *name;

@end
