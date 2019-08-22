//
//  TMXGroupsViewController.h
//  MeterRead
//
//  Created by Tim Millard on 15/06/14.
//  Copyright (c) 2014 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Group.h"

@interface TMXGroupsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)reloadTableView;

@end
