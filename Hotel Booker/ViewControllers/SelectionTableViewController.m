//
//  SelectionTableViewController.m
//  Hotel Booker
//
//  Created by Matt Graham on 26/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "SelectionTableViewController.h"
#import "Palette.h"
#import "UIViewController+ViewControllerUtils.h"

@interface SelectionTableViewControllerDataSource ()  {
	NSMutableIndexSet *_selectedIndexes;
}

@property (nonatomic) NSMutableIndexSet *provisionallySelectedIndexes;

@end

@implementation SelectionTableViewControllerDataSource

- (NSIndexSet *)selectedIndexes {
	if (!_selectedIndexes) {
		_selectedIndexes = [NSMutableIndexSet new];
	}
	return _selectedIndexes;
}

- (void)setSelectedIndexes:(NSIndexSet *)selectedIndexes {
	_selectedIndexes = [NSMutableIndexSet indexSet];
	[_selectedIndexes addIndexes:selectedIndexes];
	
	[self resetProvisionalSelection];
}

- (NSArray *)selectedObjects {
	return [self.objects objectsAtIndexes:self.selectedIndexes];
}

- (void)setSelectedObjects:(NSArray *)selectedObjects {
	NSIndexSet *indexes = [self.objects indexesOfObjectsPassingTest:
						   ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
							   return [selectedObjects indexOfObject:obj] != NSNotFound;
						   }];
	self.selectedIndexes = indexes;
}

- (NSMutableIndexSet *)provisionallySelectedIndexes {
	if (!_provisionallySelectedIndexes) {
		_provisionallySelectedIndexes = [NSMutableIndexSet new];
	}
	return _provisionallySelectedIndexes;
}

- (NSArray *)provisionallySelectedObjects {
	return [self.objects objectsAtIndexes:self.provisionallySelectedIndexes];
}

- (void)toggleIndexSelection:(NSUInteger)index {
	if (self.allowsMultipleSelection) {
		if ([self.provisionallySelectedIndexes containsIndex:index]) {
			// already selected, so deselect
			[self.provisionallySelectedIndexes removeIndex:index];
		}
		else {
			[self.provisionallySelectedIndexes addIndex:index];
		}
	}
	else {
		[self.provisionallySelectedIndexes removeAllIndexes];
		[self.provisionallySelectedIndexes addIndex:index];
	}
}

- (void)applyProvisionalSelection {
	_selectedIndexes = [self.provisionallySelectedIndexes mutableCopy];
}

- (void)resetProvisionalSelection {
	self.provisionallySelectedIndexes = [_selectedIndexes mutableCopy];
}

- (BOOL)isBranchNode {
	for (id obj in self.objects) {
		if ([obj isKindOfClass:self.class]) {
			return YES;
		}
	}
	return NO;
}

@end

@interface SelectionTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation SelectionTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.allowsMultipleSelection = self.dataSource.allowsMultipleSelection;
	[self updateNavBar];
	
	// reset the provisional selection, in case the data source has been re-used
	[self.dataSource resetProvisionalSelection];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if ([self.dataSource isBranchNode]) {
		// update any table view cell detail items that may have changed
		[self.tableView reloadData];
	}
}

- (void)updateNavBar {
	// only have cancel button, if we're the root view controller
	self.navigationItem.leftBarButtonItem = [self isRootViewController] ? self.cancelButton : nil;
	
	// only need a done button, if multiselecting or to confirm changes at a branch node level.
	self.navigationItem.rightBarButtonItem = (self.dataSource.allowsMultipleSelection ||
											  [self.dataSource isBranchNode]) ? self.doneButton : nil;
	
	self.navigationItem.title = self.dataSource.titleString;
}

- (IBAction)cancelButtonPressed:(id)sender {
	if (self.delegate) {
		[self.delegate selectionTableViewControllerCancelled:self];
	}
	[self dismiss];
}

- (IBAction)doneButtonPressed:(id)sender {
	if ([self isValid]) {
		[self informDelegateOfSelectedObjects];
		[self dismiss];
	}
}

- (void)dismiss {
	if ([self isRootViewController]) {
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}

- (void)informDelegateOfSelectedObjects {
	[self.dataSource applyProvisionalSelection];
	if (self.delegate) {
		[self.delegate selectionTableViewController:self
									objectsSelected:self.dataSource.selectedObjects];
	}
}

- (BOOL)isValid {
	if (self.dataSource.selectedObjectsValidator) {
		return self.dataSource.selectedObjectsValidator(self.dataSource.provisionallySelectedObjects);
	}
	else {
		return YES;
	}
}

#pragma mark - Table view delegate and data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSource.objects.count;
}

// This is just to avoid compiler errors/warnings relating to the descriptionImage selector
- (UIImage *)descriptionImage {
	return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[tableView setLayoutMargins:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionTableViewCell" forIndexPath:indexPath];
	
	cell.tintColor = TRAVELPORT_BLUE;
	id object = self.dataSource.objects[indexPath.row];
	
	NSString *detailString = nil;

	if ([object isKindOfClass:SelectionTableViewControllerDataSource.class]) {
		SelectionTableViewControllerDataSource *dataSource = (SelectionTableViewControllerDataSource *)object;
		cell.textLabel.text = dataSource.titleString;
		if (dataSource.objectsDescriptionProvider) {
			detailString = dataSource.objectsDescriptionProvider(dataSource.selectedObjects);
		} else {
			detailString = [dataSource.selectedObjects componentsJoinedByString:@", "];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else {
		BOOL imageSet = NO;
		if ([object respondsToSelector:@selector(descriptionImage)]) {
			UIImage *image = [object descriptionImage];
			if ([image isKindOfClass:UIImage.class]) {
				cell.imageView.image = image;
				cell.textLabel.text = nil;
				imageSet = YES;
			}
		}
		if (!imageSet) {
			cell.textLabel.text = [object description];
		}
		if ([self.dataSource.provisionallySelectedIndexes containsIndex:indexPath.row]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	
	// ensure we never set an empty or nil detailString, because it stop the detail string coming back if
	// subsequently set to something on iOS8
	if (!detailString || detailString.length == 0) {
		detailString = @" ";
	}
	cell.detailTextLabel.text = detailString;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *selectedObject = self.dataSource.objects[indexPath.row];
	
	if ([selectedObject isKindOfClass:SelectionTableViewControllerDataSource.class]) {
		SelectionTableViewControllerDataSource *dataSource = (SelectionTableViewControllerDataSource *)selectedObject;
		if (dataSource.segueId) {
			// push the specified view controller
			[self performSegueWithIdentifier:dataSource.segueId sender:self];
		}
		else {
			// push another selection view controller for the next level in the tree
			SelectionTableViewController *selectionViewController = [[UIStoryboard storyboardWithName:@"Main"
																							   bundle:nil]
																	 instantiateViewControllerWithIdentifier:@"SelectionTableViewController"];
			selectionViewController.delegate = self.delegate;
			selectionViewController.dataSource = dataSource;
			[self.navigationController pushViewController:selectionViewController animated:YES];
		}
	}
	else {
		[self.dataSource toggleIndexSelection:indexPath.row];
		if (!self.dataSource.allowsMultipleSelection) {
			// report the selection immediately
			[self informDelegateOfSelectedObjects];
			[self dismiss];
		}
		
		[self.tableView reloadData];
	}
}

@end
