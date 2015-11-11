//
//  BookingViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BookingViewController.h"
#import "BookingFormViewController.h"
#import "UIViewController+ViewControllerUtils.h"
#import "HotelApi.h"
#import "BookingConfirmationViewController.h"

#define PAY_NOW_BUTTON_HEIGHT 50.0F

@interface BookingViewController ()

@property (nonatomic) BookingFormViewController *bookingFormViewController;
@property (nonatomic) BookingInfo *bookingInfo;
@property (nonatomic) HotelBookingResponse *response;

@end

@implementation BookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self registerForKeyboardNotifications];
	[self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// the scrollview goes to the bottom of the screen, behind the pay now button. This is ensure that
	// when the keyboard appears and we shrink the scrollview, it works correctly. But it means that
	// we need to add a bottom inset to the scrollview
	self.scrollView.contentInset = UIEdgeInsetsMake(0.0F, 0.0F, PAY_NOW_BUTTON_HEIGHT, 0.0F);
	self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}

-(void)dealloc {
	[self deregisterFromKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
	self.rateDescriptionLabel.text = self.rateDetail.rateDescription;
	self.ratesTableHeader.searchData = self.searchData;
	self.totalAmountLabel.text = self.rateDetail.total.formattedCurrency;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	// hide keyboard for rotations
	[self.view endEditing:YES];
	
	// if we're in landscape, we need to move the scrollview up, otherwise it can't be seen
	BOOL isLandscape = toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;

	[self.view layoutIfNeeded];
	
	if (isLandscape) {
		self.scrollViewTopOffsetConstraint.constant = -self.headerView.frame.size.height;
	}
	else {
		self.scrollViewTopOffsetConstraint.constant = 0;
	}
	
	[UIView animateWithDuration:duration animations:^{
		if (isLandscape) {
			[self.view setNeedsLayout];
			[self.view layoutIfNeeded];
			[self.view setNeedsUpdateConstraints];
			[self.view updateConstraints];
		}
	}];
}

- (IBAction)payNowClicked:(id)sender {
	self.bookingInfo = [self.bookingFormViewController populateBookingInfo];
	if (![self.bookingInfo validate]) {
		[self showErrorMessage:NSLocalizedString(@"Please ensure that all fields are valid and try again.", @"")];
		return;
	}
	
	[self showActivityIndicator];
	[HotelApi.sharedInstance book:self.bookingInfo success:
	 ^(HotelBookingResponse *response) {
		 [self hideActivityIndicator];

		 self.response = response;
		 [self performSegueWithIdentifier:@"ShowBookingConfirmation" sender:self];
	 } failure:
	 ^(NSError *error) {
		 [self hideActivityIndicator];

		 [self showErrorMessage:NSLocalizedString(@"Please check your payment details and try again.", @"")
					  withTitle:NSLocalizedString(@"Payment Unsuccessful.", @"")];
	 }
	];
}

- (void)showActivityIndicator {
	[self.indicatorContainer.superview bringSubviewToFront:self.indicatorContainer];
	self.indicatorContainer.hidden = NO;
	[self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
	[self.activityIndicator stopAnimating];
	self.indicatorContainer.hidden = YES;
}

#pragma mark - keyboard handling

- (void)registerForKeyboardNotifications {
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification *)notification {
	CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardRect = [self.view.window convertRect:keyboardRect fromView:self.view.window.rootViewController.view];
	CGSize keyboardSize = keyboardRect.size;
	
	UIEdgeInsets insets = UIEdgeInsetsMake(0.0F, 0.0F, keyboardSize.height, 0.0F);
	
	[UIView animateWithDuration:0.3 animations:^{
		self.scrollView.contentInset = insets;
		self.scrollView.scrollIndicatorInsets = insets;
	}];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
	UIEdgeInsets insets = UIEdgeInsetsMake(0.0F, 0.0F, PAY_NOW_BUTTON_HEIGHT, 0.0F);
	
	[UIView animateWithDuration:0.3 animations:^{
		self.scrollView.contentInset = insets;
		self.scrollView.scrollIndicatorInsets = insets;
	}];
}

- (void)deregisterFromKeyboardNotifications {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"EmbedBookingForm"]) {
		self.bookingFormViewController = segue.destinationViewController;
		self.bookingFormViewController.rateDetail = self.rateDetail;
		self.bookingFormViewController.searchData = self.searchData;
		self.bookingFormViewController.hotelCompact = self.hotelCompact;
		self.bookingFormViewController.hotelDetailsResult = self.hotelDetailsResult;
	}
	else if ([segue.identifier isEqualToString:@"ShowBookingConfirmation"]) {
		UINavigationController *navigationController = segue.destinationViewController;
		BookingConfirmationViewController *bookingConfirmationViewController = navigationController.viewControllers.firstObject;
		bookingConfirmationViewController.emailAddress = self.bookingInfo.emailAddress;
		bookingConfirmationViewController.response = self.response;
	}
}


@end
