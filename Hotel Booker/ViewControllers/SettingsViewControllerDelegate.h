//
//  SettingsViewControllerDelegate.h
//  Hotel Booker
//
//  Created by Matt Graham on 10/07/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectionTableViewController.h"

@interface SettingsViewControllerDelegate : NSObject <SelectionTableViewControllerDelegate>

- (instancetype)initWithSelectionTableViewController:(SelectionTableViewController *)selectionTableViewController;

@end
