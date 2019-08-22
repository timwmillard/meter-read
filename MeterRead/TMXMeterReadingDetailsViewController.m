//
//  TMXMeterReadingDetailsViewController.m
//  MeterRead
//
//  Created by Tim Millard on 8/06/14.
//  Copyright (c) 2014 Timix Technology. All rights reserved.
//

#import "TMXMeterReadingDetailsViewController.h"

@interface TMXMeterReadingDetailsViewController ()

@end

@implementation TMXMeterReadingDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.servicePoint.name;
    
    MeterReading *reading = self.meterReading;
    
    self.meterReadingLabel.text = reading.readingString;
    self.abaLabel.text = reading.allocationBankAccount.name;
    self.dateTimeLabel.text = reading.dateTimeString;
    if (reading.isSystemReading)
        self.readByLabel.text = @"System";
    else
        self.readByLabel.text = reading.readBy;
    self.commentTextView.text = reading.comment;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
