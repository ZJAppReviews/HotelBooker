//
//  SettingsViewControllerDelegate.m
//  Hotel Booker
//
//  Created by Matt Graham on 10/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "SettingsViewControllerDelegate.h"
#import "UserSettings.h"
#import "UIViewController+ViewControllerUtils.h"

@implementation SettingsViewControllerDelegate

- (instancetype)initWithSelectionTableViewController:(SelectionTableViewController *)selectionTableViewController {
	if (self = [super init]) {
		selectionTableViewController.delegate = self;
		
		// Providers
		SelectionTableViewControllerDataSource *providerDataSource = [SelectionTableViewControllerDataSource new];
		providerDataSource.titleString = NSLocalizedString(@"Provider", @"");
		providerDataSource.objects = [[ResultsProvider allProviders] sortedArrayUsingComparator:
									  ^NSComparisonResult(ResultsProvider *provider1, ResultsProvider *provider2) {
										  return [provider1.name localizedCaseInsensitiveCompare:provider2.name];
									  }];
		providerDataSource.selectedObjects = [UserSettings.sharedInstance resultsProviders];
		providerDataSource.allowsMultipleSelection = YES;
		providerDataSource.selectedObjectsValidator =
		^BOOL(NSArray *selectedObjects) {
			BOOL isValid = selectedObjects.count > 0;
			if (!isValid) {
				[selectionTableViewController showErrorMessage:NSLocalizedString(@"Please select at least one provider", @"")];
			}
			return isValid;
		};

		// Environments
		SelectionTableViewControllerDataSource *environmentDataSource = [SelectionTableViewControllerDataSource new];
		environmentDataSource.titleString = NSLocalizedString(@"Environment", @"");
		environmentDataSource.objects = [ResultsEnvironment allEnvironments];
		environmentDataSource.selectedObjects = @[[UserSettings.sharedInstance resultsEnvironment]];
		environmentDataSource.allowsMultipleSelection = NO;

		// About
		SelectionTableViewControllerDataSource *aboutDataSource = [SelectionTableViewControllerDataSource new];
		aboutDataSource.titleString = NSLocalizedString(@"About", @"");
		aboutDataSource.segueId = @"ShowAbout";
	
		// Licenses
		SelectionTableViewControllerDataSource *licensesDataSource = [SelectionTableViewControllerDataSource new];
		licensesDataSource.titleString = NSLocalizedString(@"Open-source licenses", @"");
		licensesDataSource.segueId = @"ShowAboutOpenSourceLicenses";
		
		SelectionTableViewControllerDataSource *settingsDataSource = [SelectionTableViewControllerDataSource new];
		settingsDataSource.titleString = NSLocalizedString(@"Settings", @"");
		settingsDataSource.objects = @[
									   providerDataSource,
									   environmentDataSource,
									   aboutDataSource,
									   licensesDataSource
									   ];
		selectionTableViewController.dataSource = settingsDataSource;
	}
	return self;
}

- (void)selectionTableViewController:(SelectionTableViewController *)selectionTableViewController objectsSelected:(NSArray *)objects {
	SelectionTableViewControllerDataSource *providerDataSource = selectionTableViewController.dataSource.objects.firstObject;
	if ([providerDataSource isKindOfClass:SelectionTableViewControllerDataSource.class]) {
		// we are only interested in the top level Done button being pressed
		[UserSettings.sharedInstance setResultsProviders:providerDataSource.selectedObjects];
		
		SelectionTableViewControllerDataSource *environmentDataSource = selectionTableViewController.dataSource.objects[1];
		[UserSettings.sharedInstance setResultsEnvironment:environmentDataSource.selectedObjects.firstObject];
	}
}

-(void)selectionTableViewControllerCancelled:(SelectionTableViewController *)selectionTableViewController {
	
}

@end
