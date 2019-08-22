//
//  TMXReadByViewController.h
//  MeterRead
//
//  Created by Tim Millard on 28/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMXReadByViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *readByTextField;

- (IBAction)save:(id)sender;

@end
