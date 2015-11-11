//
//  BaseViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 12/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BaseViewController.h"
#import "NSObject+ObjectUtils.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// add gesture recogniser to remove keyboard when clicking outside an editor
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
	tapGesture.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UITapGestureRecognizer *)gesture {
	// delay this, so that it doesn't interfere with certain touch events
	[self performBlock:
	 ^{
		 [self.view endEditing:YES];
	 } afterDelay:0.01];
}

@end
