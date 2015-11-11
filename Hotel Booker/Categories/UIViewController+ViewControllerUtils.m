//
//  UIViewController+ViewControllerUtils.m
//  Hotel Booker
//
//  Created by Matt Graham on 28/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "UIViewController+ViewControllerUtils.h"

@implementation UIViewController (ViewControllerUtils)

- (BOOL)isRootViewController {
	return self.navigationController.viewControllers.firstObject == self;
}

- (void)showErrorMessage:(NSString *)message {
	[self showErrorMessage:message withTitle:NSLocalizedString(@"Error", @"")];
}

- (void)showErrorMessage:(NSString *)message withTitle:(NSString *)title {
	[[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
