//
//  SearchBarWithResults.h
//  Hotel Booker
//
//  Created by Matt Graham on 20/05/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchBarWithResults;

@protocol SearchBarWithResultsDataSource
// call the completion handler when the results have been collected
- (void)searchBarWithResults:(SearchBarWithResults *)searchBar
		completionsForString:(NSString *)string
		   completionHandler:(void(^)(NSArray *completions, NSError *error))handler;
@end

/**
 Represents a UISearchBar that shows a table of results matching the entered text.
 Users of this class much provide a SearchBarWithResultsDataSource to provide matches for the text. Each object's 
 "description" is used as its text in the results table that drops down below the input field. If the object also
 provides a "subDescription", it is used as the subtitle in the table cell.
 The latest result selected by the user is stored in selectedResult. This will be one of the objects from the 
 completions array passed to the completionHandler by the SearchBarWithResultsDataSource. This is cleared whenever the 
 text is edited.
 */
IB_DESIGNABLE
@interface SearchBarWithResults : UISearchBar

@property (weak, nonatomic) id<SearchBarWithResultsDataSource> dataSource;
@property (nonatomic) IBInspectable NSUInteger minimumStringLengthToMatch;
@property (nonatomic) IBInspectable double autoCompleteDelay;
@property (nonatomic) id selectedResult;

@end
