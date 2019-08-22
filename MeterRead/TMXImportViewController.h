//
//  TMXImportViewController.h
//  MeterRead
//
//  Created by Tim Millard on 19/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMXImportViewController : UIViewController
                                    <UITableViewDelegate,
                                     UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)cancel:(id)sender;

@end
