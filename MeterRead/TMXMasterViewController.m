//
//  TMXMasterViewController.m
//  MeterRead
//
//  Created by Tim Millard on 20/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//


#import "TMXMasterViewController.h"

#import "TMXDetailsViewController.h"
#import "TMXSettingsViewController.h"
#import "TMXExportOperation.h"

#import "ServicePoint.h"

@interface TMXMasterViewController ()

//@property (nonatomic, strong) UIActivityIndicatorView *spinner;

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation TMXMasterViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.tableView reloadData];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
        _fetchedResultsController = nil;
        _searchFetchedResultsController = nil;
      //  self.subView = nil;
      //  self.subViewFromNib = nil;
    }
    //self.someDataCanBeRecreatedEasily = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        UITableView *tableView;
        if (self.searchDisplayController.active) {
            tableView = self.searchDisplayController.searchResultsTableView;
        } else {
            tableView = self.tableView;
        }
        
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        NSFetchedResultsController *resultsController = [self fetchedResultsControllerForTableView:tableView];
        ServicePoint *object = [resultsController objectAtIndexPath:indexPath];
        TMXDetailsViewController *controller = [segue destinationViewController];
        controller.servicePoint = object;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSFetchedResultsController *resultsController = [self fetchedResultsControllerForTableView:tableView];
    return [[resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchedResultsController *resultsController = [self fetchedResultsControllerForTableView:tableView];
    id <NSFetchedResultsSectionInfo> sectionInfo = [resultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ServicePointCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier] ; //]] forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServicePointCell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath withTableView:tableView];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }   
}*/

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSFetchedResultsController *resultsController = [self fetchedResultsControllerForTableView:tableView];
    id <NSFetchedResultsSectionInfo> sectionInfo = [resultsController sections][section];
    
    return [sectionInfo name];
}


#pragma mark - Fetched results controllers

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServicePoint" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *channelSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"channelName" ascending:YES];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[channelSortDescriptor, nameSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSDate *lastImport = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastImport"];
    NSPredicate *predicate;
    if (lastImport) {
         predicate = [NSPredicate predicateWithFormat:@"(isMetered == YES) AND (lastImport >= %@)", lastImport];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(isMetered == YES)"];
    }
    
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"channelName" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
    
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)searchFetchedResultsController
{
    if (_searchFetchedResultsController != nil) {
        return _searchFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServicePoint" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *channelSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"channelName" ascending:YES];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[channelSortDescriptor, nameSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString *searchString = self.searchBar.text;
    NSPredicate *predicate;
    if (searchString.length)
        predicate = [NSPredicate predicateWithFormat:@"(isMetered == YES) AND name CONTAINS[cd] %@", searchString];
    else
        predicate = [NSPredicate predicateWithFormat:@"(isMetered == YES)"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"channelName" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.searchFetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.searchFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
    
    return _searchFetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
        return self.fetchedResultsController;
    else
        return self.searchFetchedResultsController;
}

- (void)reloadTableView
{
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath withTableView:tableView];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    [tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if ([MFMailComposeViewController canSendMail]) {
            TMXExportOperation *export = [[TMXExportOperation alloc] init];
            
            MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
            email.mailComposeDelegate = self;
            [email setSubject:@"Meter Readings"];
            [email addAttachmentData:[export exportToData] mimeType:@"text/cvs" fileName:[export getExportFileName]];
        
            [self presentViewController:email animated:YES completion:nil];
        } else {
            NSLog(@"Mail not settup");
        }
        
    }
    
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    // if you care about the scope save off the index to be used by the serchFetchedResultsController
    //self.savedScopeButtonIndex = scope;
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
}

#pragma mark Search Bar

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    // search is done so get rid of the search FRC and reclaim memory
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - TMXMasterViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    NSFetchedResultsController *resultsController = [self fetchedResultsControllerForTableView:tableView];
    ServicePoint *servicePoint = [resultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = servicePoint.name;
    cell.detailTextLabel.text = servicePoint.meterReading.readingString;
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"mail-check-icon-24" ofType:@"png"];
    //UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    //cell.imageView.image = theImage;
    
    // Flag if no ABA is set after entering meter reading or no comment on invaild entry.
    if ((servicePoint.meterReading.reading && !servicePoint.meterReading.allocationBankAccount) ||
                    (servicePoint.meterReading.reading
                    && ![servicePoint meterReadingIsWithinTolerence]
                    && !servicePoint.meterReading.comment.length)) {
            cell.detailTextLabel.textColor = [UIColor redColor];
        } else {
            cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:2.0f/255.0f green:84.0f/255.0f blue:147.0f/255.0f alpha:1.0];
        }
}

- (IBAction)focusOnSearchBar:(id)sender
{
    [self.searchBar becomeFirstResponder];
}

- (IBAction)showActionMenu:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Export ALL meter readings via:"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Email", nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
}

@end