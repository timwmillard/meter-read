//
//  TMXDateTimeViewController.m
//  MeterRead
//
//  Created by Tim Millard on 28/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXDateTimeViewController.h"

#import "TMXAppDelegate.h"

@interface TMXDateTimeViewController ()

@end

@implementation TMXDateTimeViewController

@synthesize servicePoint = _servicePoint;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.servicePoint.meterReading && self.servicePoint.meterReading.dateTime) {
        [self setLabel:self.servicePoint.meterReading.dateTime];
        self.dateTimePicker.date = self.servicePoint.meterReading.dateTime;
    } else {
        [self setDateTimeToNow:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setDateTimeToNow:(id)sender
{
    self.dateTimePicker.date = [NSDate date];
    [self setLabel:[NSDate date]];
}

- (IBAction)updateLabel:(id)sender
{
    [self setLabel:self.dateTimePicker.date];
}

-(void)setLabel:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
    
    self.dateTimeLabel.textLabel.text = [dateFormatter stringFromDate:date];
}

- (IBAction)save:(id)sender
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    
    // Check date is after previous reading
    if (self.servicePoint.prevMeterReading) {
        NSDate *prevDate = self.servicePoint.prevMeterReading.dateTime;
        
        NSComparisonResult result = [self.dateTimePicker.date compare:prevDate];
        if (result == NSOrderedAscending || result == NSOrderedSame) {
            NSString *message = [NSString stringWithFormat:
                                 @"Date must be after previous meter readings date.\n  Choose date after %@.",
                                 self.servicePoint.prevMeterReading.dateTimeString];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Previous Reading Date"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        
    }
    
   // if (!self.servicePoint.meterReading) {
    //    MeterReading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
   //                                                                   inManagedObjectContext:delegate.managedObjectContext];
    //    [self.servicePoint addMeterReadingsObject:reading];
    //}
    
    self.servicePoint.meterReading.dateTime = self.dateTimePicker.date;
    
    [self.servicePoint willChangeValueForKey:@"meterReadings"];
    [self.servicePoint didChangeValueForKey:@"meterReadings"];
    
    [delegate saveContext];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
