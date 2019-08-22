//
//  TMXAllocBankAccountViewController.h
//  MeterRead
//
//  Created by Tim Millard on 28/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServicePoint.h"
#import "AllocationBankAccount.h"
#import "MeterReading.h"

@interface TMXAllocBankAccountViewController : UITableViewController

@property (strong, nonatomic) ServicePoint *servicePoint;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
