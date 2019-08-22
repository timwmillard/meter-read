//
//  TMXMeterReadingViewController.m
//  MeterRead
//
//  Created by Tim Millard on 28/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXMeterReadingViewController.h"

#import "TMXAppDelegate.h"

@interface TMXMeterReadingViewController ()

@end

@implementation TMXMeterReadingViewController

@synthesize servicePoint = _servicePoint;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.meterReadingTextField becomeFirstResponder];
    
    double expectedReading = self.servicePoint.prevMeterReading.reading.doubleValue + self.servicePoint.meterReading.allocationBankAccount.estimatedUsage.doubleValue;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:3];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
    
        
    self.servicePointLabel.text = self.servicePoint.name;
    self.abaLabel.text = self.servicePoint.meterReading.allocationBankAccount.name;
    self.prevMeterReadingLabel.text = [NSString stringWithFormat:@"%@ ML (%@)",
                                        self.servicePoint.prevMeterReading.readingString,
                                       [dateFormatter stringFromDate:self.servicePoint.prevMeterReading.dateTime]];

    self.estimateUsageLabel.text = self.servicePoint.meterReading.allocationBankAccount.estimatedUsage.stringValue;

    self.expectedReadingLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:expectedReading]];
    self.meterReadingTextField.text = self.servicePoint.meterReading.readingString;
    [self updateActualUsage];
}

- (IBAction)updateActualUsage
{   
    double meterReading = self.meterReadingTextField.text.doubleValue;
    double prevMeterReading = self.servicePoint.prevMeterReading.reading.doubleValue;
    double actualUsage = meterReading - prevMeterReading;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:3];
    [numberFormatter setPerMillSymbol:@""];
    [numberFormatter setUsesGroupingSeparator:NO];
    
    if (self.meterReadingTextField.text.length==0)
        self.actualUsageLabel.text = @" ";
    else
        self.actualUsageLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:actualUsage]];
    
    if ([self.servicePoint meterReadingIsWithinTolerenceForReading:[NSNumber numberWithDouble:meterReading]]){
        self.actualUsageLabel.textColor = [UIColor blackColor];
    } else {
        self.actualUsageLabel.textColor = [UIColor redColor];
    }
    
    [self.actualUsageLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
   // if (!self.servicePoint.meterReading) {
   //     MeterReading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
     //                                                                 inManagedObjectContext:delegate.managedObjectContext];
    //    [self.servicePoint addMeterReadingsObject:reading];
   // }
    
    if (self.meterReadingTextField.text.length==0) {
        self.servicePoint.meterReading.reading = nil;
        self.servicePoint.meterReading.readBy = nil;
    } else {
        self.servicePoint.meterReading.reading = [NSNumber numberWithDouble:self.meterReadingTextField.text.doubleValue];
        self.servicePoint.meterReading.dateTime = [NSDate date];
        
        NSString *readBy = [[NSUserDefaults standardUserDefaults] stringForKey:@"readBy"];
        if (!readBy.length)
            readBy = [[UIDevice currentDevice] name];
        self.servicePoint.meterReading.readBy = readBy;
    }
    
    [self.servicePoint willChangeValueForKey:@"meterReadings"];
    [self.servicePoint didChangeValueForKey:@"meterReadings"];
    
    [delegate saveContext];

    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
