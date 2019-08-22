//
//  TMXMeterReadingHistoryViewController.h
//  MeterRead
//
//  Created by Tim Millard on 22/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServicePoint.h"
#import "AllocationBankAccount.h"
#import "MeterReading.h"

@interface TMXMeterReadingHistoryViewController : UITableViewController

@property (strong, nonatomic) ServicePoint *servicePoint;

@end
