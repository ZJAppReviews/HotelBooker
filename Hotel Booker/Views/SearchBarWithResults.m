//
//  SearchBarWithResults.m
//  Hotel Booker
//
//  Created by Matt Graham on 20/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "SearchBarWithResults.h"
#import "UIView+ViewUtils.h"

#define TABLEVIEW_CELL_HEIGHT 44
#define TABLEVIEW_MAX_HEIGHT_IN_CELLS 4
#define DEFAULT_MIN_STRING_LENGTH 2
#define DEFAULT_AUTO_COMPLETE_DELAY 0.2
#define SPINNER_TAG 8642

@interface SearchBarWithResultsError : NSObject

@end

@implementation SearchBarWithResultsError

- (NSString *)description {
	return NSLocalizedString(@"No matches found", @"");
}

- (NSString *)subDescription {
	return NSLocalizedString(@"Please ensure you have connectivity and keep trying", @"");
}

@end

@interface SearchBarWithResults() <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) id<UISearchBarDelegate> outerDelegate;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic) BOOL showingSpinner;
@property (nonatomic) NSLayoutConstraint* tableHeightConstraint;

@end

@implementation SearchBarWithResults

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[self setUp:YES];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		[self setUp:NO];
	}
	return self;
}

- (void) setUp:(BOOL)fromCoder {
	self.delegate = self;
	self.minimumStringLengthToMatch = DEFAULT_MIN_STRING_LENGTH;
	self.autoCompleteDelay = DEFAULT_AUTO_COMPLETE_DELAY;
	self.searchResults = [NSArray new];
	[self themeSearchBar];
}

- (void)themeSearchBar {
	UITextField *textField = [self findTextFieldInView:self];
	
	if(textField) {
		textField.background = [UIImage new];
		textField.borderStyle = UITextBorderStyleNone;
		textField.tintColor = UIColor.grayColor;
	}
}

- (UITextField *)findTextFieldInView:(UIView *)view {
	for (UIView *subView in view.subviews) {
		if([subView isKindOfClass:[UITextField class]]) {
			return (UITextField *)subView;
		} else {
			UITextField *textField = [self findTextFieldInView:subView];
			if (textField) {
				return textField;
			}
		}
	}
	
	return nil;
}

- (void)setDelegate:(id<UISearchBarDelegate>)delegate {
	if (delegate != self) {
		self.outerDelegate = delegate;
	}
	else {
		[super setDelegate:delegate];
	}
}

- (void)setSearchResults:(NSArray *)searchResults {
	_searchResults = searchResults;
	[self.tableView reloadData];
}

- (void)setShowingSpinner:(BOOL)showingSpinner {
	_showingSpinner = showingSpinner;
	[self.tableView reloadData];
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self createResultsView];
}

#pragma mark Results Table Managements

- (void)createResultsView {
	CGRect rect = self.frame;
	// display results table view below search bar
	rect.origin.y += rect.size.height;
	self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self setResultsTableHeight:[self tableView:self.tableView numberOfRowsInSection:0]];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	[self.superview addSubview:self.tableView];
	CGFloat leftConstraint = rect.origin.x;
	CGFloat rightConstraint = self.superview.frame.size.width - (leftConstraint + rect.size.width);
	[self.superview addOrModifyConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
																	   attribute:NSLayoutAttributeTop
																	   relatedBy:NSLayoutRelationEqual
																		  toItem:self
																	   attribute:NSLayoutAttributeBottom
																	  multiplier:1.0
																		constant:0.0]];
	[self.superview addLeftLayoutConstraintWithChild:self.tableView value:leftConstraint];
	[self.superview addRightLayoutConstraintWithChild:self.tableView value:-rightConstraint];
	self.tableHeightConstraint = [self.tableView addFixedHeightConstraint:0.0F];
	[self.superview setNeedsUpdateConstraints];
	[self updateConstraintsIfNeeded];
}

- (void)showResultsView {
	[self.tableView.superview bringSubviewToFront:self.tableView];
	self.tableView.hidden = NO;
}

- (void)hideResultsTable {
	self.tableView.hidden = YES;
}

- (void)setResultsTableHeight:(NSInteger)count {
	NSInteger numCellsToShow = MIN(count, TABLEVIEW_MAX_HEIGHT_IN_CELLS);
	CGFloat height = numCellsToShow * TABLEVIEW_CELL_HEIGHT;
	self.tableHeightConstraint.constant = height;
}

- (void)showActivityIndicator {
	self.showingSpinner = YES;
}

- (void)hideActivityIndicator {
	self.showingSpinner = NO;
}

- (void) refreshResults {
	NSLog(@"REFRESHRESULTS");

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRefreshResults) object:nil];
	
	[self performSelector:@selector(doRefreshResults) withObject:nil afterDelay:self.autoCompleteDelay];
}

- (void) doRefreshResults {
	if (self.dataSource) {

		__weak SearchBarWithResults *weakSelf = self;
		NSString *searchText = [self.text copy];
		
		if (searchText.length >= self.minimumStringLengthToMatch) {
			[self showActivityIndicator];
			NSLog(@"SearchBarResults - SEARCHING: %@", searchText);
			[self.dataSource searchBarWithResults:self completionsForString:searchText completionHandler:
			 ^(NSArray *completions, NSError *error) {
				 if (weakSelf) {
					 [weakSelf hideActivityIndicator];
					 [weakSelf handleSearchResults:searchText completions:completions error:error];
				 }
			 }];
		}
		else {
			self.searchResults = [NSArray new];
		}
	}
}

- (void)handleSearchResults:(NSString *)searchText completions:(NSArray *)completions error:(NSError *)error {
	// only use the results if they still match the text that is in the search box
	if ([self.text isEqualToString:searchText]) {
		if (error) {
			NSLog(@"SearchBarResults - %@ ERROR %@", searchText, error);
			self.searchResults = @[[SearchBarWithResultsError new]];
		}
		else {
			NSLog(@"SearchBarResults - %@ GOT %ld RESULTS", searchText, (unsigned long)completions.count);
			self.searchResults = completions;
		}
	}
	else {
		NSLog(@"SearchBarResults - STRING HAD CHANGED: %@ != %@", self.text, searchText);
	}
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	BOOL result = YES;
	
	if ([self.outerDelegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
		result = [self.outerDelegate searchBarShouldBeginEditing:searchBar];
	}
	
	return result;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	if ([self.outerDelegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
		[self.outerDelegate searchBarTextDidBeginEditing:searchBar];
	}
	
	[self showResultsView];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	BOOL result = YES;
	
	if ([self.outerDelegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
		result = [self.outerDelegate searchBarShouldEndEditing:searchBar];
	}
	
	return result;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	if ([self.outerDelegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
		[self.outerDelegate searchBarTextDidEndEditing:searchBar];
	}
	
	[self hideResultsTable];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	if ([self.outerDelegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
		[self.outerDelegate searchBar:searchBar textDidChange:searchText];
	}
	
	self.selectedResult = nil;
	
	[self refreshResults];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	BOOL result = YES;
	
	if ([self.outerDelegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
		result = [self.outerDelegate searchBar:searchBar shouldChangeTextInRange:range replacementText:text];
	}
	
	return result;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if ([self.outerDelegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
		[self.outerDelegate searchBarSearchButtonClicked:searchBar];
	}
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
	if ([self.outerDelegate respondsToSelector:@selector(searchBarBookmarkButtonClicked:)]) {
		[self.outerDelegate searchBarBookmarkButtonClicked:searchBar];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	if ([self.outerDelegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
		[self.outerDelegate searchBarCancelButtonClicked:searchBar];
	}
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
	if ([self.outerDelegate respondsToSelector:@selector(searchBarResultsListButtonClicked:)]) {
		[self.outerDelegate searchBarResultsListButtonClicked:searchBar];
	}
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	if ([self.outerDelegate respondsToSelector:@selector(searchBar:selectedScopeButtonIndexDidChange:)]) {
		[self.outerDelegate searchBar:searchBar selectedScopeButtonIndexDidChange:selectedScope];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = self.showingSpinner ? 1 : self.searchResults.count;
	[self setResultsTableHeight:count];
	return count;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.showingSpinner) {
		return [self createSpinnerCell:tableView];
	}
	
	NSString *reuseIdentifier = @"UITableViewCellDefault";
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	
	NSObject *element = self.searchResults[indexPath.row];
	BOOL hasSubtitle = [element respondsToSelector:@selector(subDescription)];
	if (hasSubtitle) {
		reuseIdentifier = @"UITableViewCellSubtitle";
		cellStyle = UITableViewCellStyleSubtitle;
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
	}

	cell.textLabel.text = [element description];
	if (hasSubtitle) {
		cell.detailTextLabel.text = [element performSelector:@selector(subDescription) withObject:nil];
	}
	
	return cell;
}

- (UITableViewCell *)createSpinnerCell:(UITableView *)tableView {
	static NSString *reuseIdentifier = @"UITableViewCellSpinner";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	}
	
	UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:SPINNER_TAG];
	if (!spinner) {
		spinner = [[UIActivityIndicatorView alloc]
											initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		CGRect frame = cell.bounds;
		// ensure spinner is in the middle
		frame.size.width = self.frame.size.width;
		spinner.frame = frame;
		spinner.tag = SPINNER_TAG;
		[cell addSubview: spinner];
	}
	
	[spinner startAnimating];

	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.showingSpinner) {
		return;
	}
	
	NSObject *selectedElement = self.searchResults[indexPath.row];

	NSString *subDescription = [selectedElement respondsToSelector:@selector(subDescription)] ? [selectedElement performSelector:@selector(subDescription) withObject:nil] : nil;
	if (subDescription) {
		self.text = [NSString stringWithFormat:@"%@, %@", selectedElement.description, subDescription];
	} else {
		self.text = selectedElement.description;
	}

	self.selectedResult = selectedElement;
}

#pragma clang diagnostic pop

@end
