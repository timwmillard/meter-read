//
//  TMXCommentViewController.m
//  MeterRead
//
//  Created by Tim Millard on 26/05/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXCommentViewController.h"
#import "TMXAppDelegate.h"


@interface TMXCommentViewController ()

@end

@implementation TMXCommentViewController

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

    self.commentTextView.text = self.servicePoint.meterReading.comment;
    
    [self.commentTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)autoFillComment:(id)sender
{
    if (sender==self.autoFillButton1) {
        self.commentTextView.text = @"Flow or duration varied from order.";
    } else if (sender==self.autoFillButton2) {
        self.commentTextView.text = @"Water taken with out an order.";
    } else if (sender==self.autoFillButton3) {
        self.commentTextView.text = @"Meter has previouly been read incorrectly.";
    } else if (sender==self.autoFillButton4) {
        self.commentTextView.text = @"The meter is broken.";
    }
}

- (IBAction)save:(id)sender
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    //if (!self.servicePoint.meterReading) {
   //     MeterReading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
    //                                                                  inManagedObjectContext:delegate.managedObjectContext];
     //   [self.servicePoint addMeterReadingsObject:reading];
    //}
    
    self.servicePoint.meterReading.comment = self.commentTextView.text;
    
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
