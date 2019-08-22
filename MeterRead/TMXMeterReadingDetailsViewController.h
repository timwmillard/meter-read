//
//  TMXMeterReadingDetailsViewController.h
//  MeterRead
//
//  Created by Tim Millard on 8/06/14.
//  Copyright (c) 2014 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServicePoint.h"
#import "AllocationBankAccount.h"
#import "MeterReading.h"

@interface TMXMeterReadingDetailsViewController : UIViewController

@property (strong, nonatomic) ServicePoint *servicePoint;
@property (strong, nonatomic) MeterReading *meterReading;

@property (weak, nonatomic) IBOutlet UILabel *meterReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *abaLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readByLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end
