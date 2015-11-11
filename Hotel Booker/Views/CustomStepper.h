//
//  CustomStepper.h
//  Hotel Booker
//
//  Created by Matt Graham on 19/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A Custom +/- stepper which show a lable above and the current value bewteen the - and + buttons,
 */
IB_DESIGNABLE
@interface CustomStepper : UIView

@property (nonatomic) IBInspectable NSString *label;
@property (nonatomic) IBInspectable NSUInteger value;
@property (nonatomic) IBInspectable NSUInteger minValue;
@property (nonatomic) IBInspectable NSUInteger maxValue;

@end
