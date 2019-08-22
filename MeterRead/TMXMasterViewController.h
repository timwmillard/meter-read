//
//  TMXMasterViewController.h
//  MeterRead
//
//  Created by Tim Millard on 20/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreData/CoreData.h>

#import "TMXAppDelegate.h"
#import "TMXImportOperation.h"

@interface TMXMasterViewController : UITableViewController
                                    <NSFetchedResultsControllerDelegate,
                                     UISearchDisplayDelegate,
                                     UISearchBarDelegate,
                                     UIActionSheetDelegate,
                                     MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *searchFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)showActionMenu:(id)sender;
- (IBAction)focusOnSearchBar:(id)sender;

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller;
- (void)reloadTableView;

@end
