//
//  BookingFormViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 25/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BookingFormViewController.h"
#import "SelectionTableViewController.h"
#import "CreditCardType.h"
#import "Palette.h"

@interface BookingFormViewController () <SelectionTableViewControllerDelegate>

@property (nonatomic) CreditCardType *creditCardType;

@end

@implementation BookingFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BookingInfo *)populateBookingInfo {
	// turn any fields red that are invalid
	[LabelledTextField validateAllInContainer:self.firstNameField.superview];
	[self updateButtonColor];
	
	BookingInfo *bookingInfo = [BookingInfo new];
	
	bookingInfo.searchData = self.searchData;
	bookingInfo.hoteCompact = self.hotelCompact;
	bookingInfo.hotelDetails = self.hotelDetailsResult;
	bookingInfo.rateDetail = self.rateDetail;
	
	bookingInfo.firstName = self.firstNameField.text;
	bookingInfo.lastName = self.lastNameField.text;
	bookingInfo.emailAddress = self.emailField.text;
	bookingInfo.phoneNumber = self.phoneNumberField.text;
	
	bookingInfo.creditCardExpiryDate = self.cardExpiryDateField.text;
	bookingInfo.creditCardNumber = self.cardNumberField.text;
	bookingInfo.creditCardType = self.creditCardType;
	
	return bookingInfo;
}

- (void)updateButtonColor {
	UIColor *color = DARK_TEXT_COLOR;
	if (!self.creditCardType) {
		color = FORM_ERROR_COLOR;
	}
	[self.cardTypeButton setTitleColor:color forState:UIControlStateNormal];
}

- (IBAction)selectCreditCardTypeClicked:(id)sender {
	[self performSegueWithIdentifier:@"ShowCreditCardTypes" sender:self];
}

#pragma mark SelectionTableViewControllerDelegate

- (void)selectionTableViewController:(SelectionTableViewController *)selectionTableViewController objectsSelected:(NSArray *)objects {
	self.creditCardType = objects.firstObject;
	[self.cardTypeButton setTitle:self.creditCardType.name forState:UIControlStateNormal];
	[self updateButtonColor];
}

- (void)selectionTableViewControllerCancelled:(SelectionTableViewController *)selectionTableViewController {
	[self updateButtonColor];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowCreditCardTypes"]) {
		UINavigationController *navController = segue.destinationViewController;
		SelectionTableViewController *selectionTableViewController = navController.viewControllers.firstObject;
		selectionTableViewController.delegate = self;
		SelectionTableViewControllerDataSource *dataSource = [SelectionTableViewControllerDataSource new];
		dataSource.titleString = @"Credit Card Type";
		dataSource.objects = CreditCardType.allTypes;
		if (self.creditCardType) {
			[dataSource setSelectedObjects:@[self.creditCardType]];
		}
		dataSource.allowsMultipleSelection = NO;
		selectionTableViewController.dataSource = dataSource;
	}
}


@end
