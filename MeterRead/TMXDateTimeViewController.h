//
//  TMXDateTimeViewController.h
//  MeterRead
//
//  Created by Tim Millard on 28/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServicePoint.h"
#import "MeterReading.h"

@interface TMXDateTimeViewController : UITableViewController

@property (strong, nonatomic) ServicePoint *servicePoint;

@property (strong, nonatomic) IBOutlet UITableViewCell *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *dateTimePicker;

- (IBAction)setDateTimeToNow:(id)sender;
- (IBAction)updateLabel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
