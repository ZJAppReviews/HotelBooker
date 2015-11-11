//
//  UIViewController+ViewControllerUtils.h
//  Hotel Booker
//
//  Created by Matt Graham on 28/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Provides View Controller-related utility functions.
 */
@interface UIViewController (ViewControllerUtils)

- (BOOL)isRootViewController;

- (void)showErrorMessage:(NSString *)message;
- (void)showErrorMessage:(NSString *)message withTitle:(NSString *)title;

@end
