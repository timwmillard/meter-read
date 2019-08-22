//
//  TMXMeterReadingViewController.h
//  MeterRead
//
//  Created by Tim Millard on 28/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServicePoint.h"
#import "MeterReading.h"
#import "AllocationBankAccount.h"

@interface TMXMeterReadingViewController : UIViewController

@property (strong, nonatomic) ServicePoint *servicePoint;

@property (strong, nonatomic) IBOutlet UILabel *servicePointLabel;
@property (strong, nonatomic) IBOutlet UILabel *abaLabel;
@property (strong, nonatomic) IBOutlet UILabel *prevMeterReadingLabel;
@property (strong, nonatomic) IBOutlet UILabel *estimateUsageLabel;
@property (strong, nonatomic) IBOutlet UILabel *expectedReadingLabel;
@property (strong, nonatomic) IBOutlet UILabel *actualUsageLabel;
@property (strong, nonatomic) IBOutlet UITextField *meterReadingTextField;

- (IBAction)updateActualUsage;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
