//
//  SelectionTableViewController.h
//  Hotel Booker
//
//  Created by Matt Graham on 26/06/2015.
//  Copyright (c) 2015 Travelport. All rights reserved.
//

#import "BaseViewController.h"

@class SelectionTableViewController;

@protocol SelectionTableViewControllerDelegate <NSObject>

- (void)selectionTableViewController:(SelectionTableViewController *)selectionTableViewController objectsSelected:(NSArray *)objects;
- (void)selectionTableViewControllerCancelled:(SelectionTableViewController *)selectionTableViewController;

@end

typedef NSString *(^ObjectsDescriptionProvider)(NSArray *);
typedef BOOL(^SelectedObjectsValidator)(NSArray *);

/**
 * Date source for the selection. The array can either contain NSObject-derived instances, in which case they 
 * represent leaves which can be selected. The object's description is used to display a choice to the user. If the
 * object has a descriptionImage, which returns a UIImage*, then this is set in the cell's ImageView.
 *
 * Alternatively, the array can contain SelectionTableViewControllerDataSource-s, in which case, they
 * represent branch nodes, which allow further navigation into the tree.
 *
 * Another option is to not provide objects, but instead provide a segueId, which should the ID of a storyboard
 * segue from the SelectionTableViewController, to perform when the item is selected.
 */
@interface SelectionTableViewControllerDataSource : NSObject

@property (nonatomic) NSString *titleString;
@property (nonatomic) NSArray *objects;
@property (nonatomic) NSString *segueId;
@property (nonatomic) NSIndexSet *selectedIndexes;
@property (nonatomic) BOOL allowsMultipleSelection;
/** Provide this block to override how a collection of selected objects are described */
@property (nonatomic, copy) ObjectsDescriptionProvider objectsDescriptionProvider;
/** Provide this block to validate the selected objects before allowing the user to go back from selection */
@property (nonatomic, copy) SelectedObjectsValidator selectedObjectsValidator;

/** Picks out the selectedIndexes from objects */
- (NSArray *)selectedObjects;
/** Can be used when objects have isEqual and hash methods to automatically populate selectedIndexes */
- (void)setSelectedObjects:(NSArray *)selectedObject;

/** Does this data source ahve and data sources as children */
- (BOOL)isBranchNode;

@end

/**
 * General purpose view controller that allows selection of one (or more) or the objects provided by the data source.
 */
@interface SelectionTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SelectionTableViewControllerDelegate> delegate;
/** Note that this is not like a uitableview data source, it is instead a data object that is passed in and it
 * therefore not weak */
@property (nonatomic) SelectionTableViewControllerDataSource *dataSource;

@end
