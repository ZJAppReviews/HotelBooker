//
//  PaddedTextField.h
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface PaddedTextField : UITextField

@property (nonatomic) IBInspectable CGFloat horizontalPadding;
@property (nonatomic) IBInspectable CGFloat verticalPadding;

@end
