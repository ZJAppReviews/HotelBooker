//
//  GuaranteeInfo.h
//  Hotel Booker
//
//  Created by Matt Graham on 30/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

FOUNDATION_EXPORT NSString * const GuaranteeInfoStringGuarantee;
FOUNDATION_EXPORT NSString * const GuaranteeInfoStringDeposit;

typedef NS_ENUM(NSUInteger, GuaranteeType) {
	GuaranteeTypeGuarantee,
	GuaranteeTypeDeposit
};

@interface GuaranteeInfo : NSObject

@property (nonatomic, readonly) GuaranteeType guaranteeType;
@property (nonatomic) NSString *guaranteeTypeString;

+ (RKObjectMapping *)rkMapping;

@end
