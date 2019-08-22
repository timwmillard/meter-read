//
//  TMXDetailsViewController.m
//  MeterRead
//
//  Created by Tim Millard on 24/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXDetailsViewController.h"

#import "TMXMapViewController.h"
#import "TMXAllocBankAccountViewController.h"
#import "TMXMeterReadingViewController.h"
#import "TMXDateTimeViewController.h"
#import "TMXCommentViewController.h"
#import "TMXMeterReadingHistoryViewController.h"
#import "TMXExportOperation.h"
#import "TMXAppDelegate.h"

@interface TMXDetailsViewController ()

@end

@implementation TMXDetailsViewController

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
    
    //[self checkSingleABA];
    
    [self displayDetails];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self checkSingleABA];
    
    [self displayDetails];
}
/*
- (void)checkSingleABA
{
    // if single ABA, set meter reading ABA.
    if (!self.servicePoint.meterReading.allocationBankAccount && self.servicePoint.allocationBankAccounts.count==1) {
        
        TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        if (!self.servicePoint.meterReading) {
            MeterReading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
                                                                  inManagedObjectContext:delegate.managedObjectContext];
            [self.servicePoint addMeterReadingsObject:reading];
        }
        
        self.servicePoint.meterReading.allocationBankAccount = (AllocationBankAccount*)[self.servicePoint.allocationBankAccounts anyObject];
        
        [delegate saveContext];
    }
}*/

- (void)displayDetails
{
    MeterReading *meterReading = self.servicePoint.meterReading;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];

    
    self.servicePointLabel.text = self.servicePoint.name;
    self.abaLabel.text = meterReading.allocationBankAccount.name;
    
    // Meter Reading
    self.meterReadingLabel.text = meterReading.readingString;
    
    // Date/Time
    self.dateTimeLabel.text = [dateFormatter stringFromDate:meterReading.dateTime];
    
    // Comment
    self.commentLabel.text = meterReading.comment;
    
    
    // Flag if no ABA is set after entering meter reading
    if (meterReading.reading && !meterReading.allocationBankAccount) {
        self.abaHeadingLabel.textColor = [UIColor redColor];
    } else {
        self.abaHeadingLabel.textColor = [UIColor blackColor];
    }
    
    // Flag if no comment is set after entering invalid meter reading
    if (meterReading.reading
                && ![self.servicePoint meterReadingIsWithinTolerence]
                && !meterReading.comment.length) {
        self.commentLabel.text = @"Enter a comment";
        self.commentLabel.textColor = [UIColor redColor];
    } else {
        self.commentLabel.text = meterReading.comment;
        self.commentLabel.textColor = [[UIColor alloc] initWithRed:2.0f/255.0f green:84.0f/255.0f blue:147.0f/255.0f alpha:1.0];
    }
    
    self.addButton.enabled = [self.servicePoint meterReadingIsCompleted];
    
    [self.tableView reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMapView"]) {
        TMXMapViewController *mapController = [segue destinationViewController];
        mapController.servicePoint = self.servicePoint;
    }
    else if ([[segue identifier] isEqualToString:@"showAllocBankAccounts"]) {
        TMXAllocBankAccountViewController *abaController = [segue destinationViewController];
        abaController.servicePoint = self.servicePoint;
    }
    else if ([[segue identifier] isEqualToString:@"showMeterReading"]) {
        TMXMeterReadingViewController *readingController = [segue destinationViewController];
        readingController.servicePoint = self.servicePoint;
    }
    else if ([[segue identifier] isEqualToString:@"showDateTime"]) {
        TMXDateTimeViewController *dateController = [segue destinationViewController];
        dateController.servicePoint = self.servicePoint;
    }
    else if ([[segue identifier] isEqualToString:@"showComment"]) {
        TMXCommentViewController *commentController = [segue destinationViewController];
        commentController.servicePoint = self.servicePoint;
    }
    else if ([[segue identifier] isEqualToString:@"showMeterReadingHistory"]) {
        TMXMeterReadingHistoryViewController *historyController = [segue destinationViewController];
        historyController.servicePoint = self.servicePoint;
    }
}

- (IBAction)showActionMenu:(id)sender
{
    NSString *title = [NSString stringWithFormat:@"Export meter reading for %@ via:", self.servicePoint.name];
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:title
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Email", nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if ([MFMailComposeViewController canSendMail]) {
            TMXExportOperation *export = [[TMXExportOperation alloc] init];
            
            MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
            email.mailComposeDelegate = self;
            
            NSString *subject = [NSString stringWithFormat:@"Meter Reading - %@", self.servicePoint.name];
            [email setSubject:subject];
            
            NSString *body = [NSString stringWithFormat:@"Meter Reading: %@-%@ %@ (%@)\nComment: %@",
                                                        self.servicePoint.name,
                                                        self.servicePoint.meterReading.allocationBankAccount.name,
                                                        self.servicePoint.meterReading.reading.stringValue,
                                                        self.servicePoint.meterReading.dateTimeString,
                                                        self.servicePoint.meterReading.comment];
            [email setMessageBody:body isHTML:NO];
            
            [email addAttachmentData:[export exportToDataForServicePoint:self.servicePoint] mimeType:@"text/cvs" fileName:[export getExportFileName]];
            
            [self presentViewController:email animated:YES completion:nil];
        } else {
            NSLog(@"Mail not settup");
        }
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addNewMeterReading:(id)sender
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
 
    if (self.servicePoint.meterReading) {
        [self.servicePoint addNewMeterReading];
        
        [delegate saveContext];
        
        [self displayDetails];
        
    }
}

/*
- (IBAction)addNewMeterReading:(id)sender
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (self.servicePoint.meterReading && self.servicePoint.meterReadingIsCompleted) {
        
        MeterReading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
                                                                      inManagedObjectContext:delegate.managedObjectContext];
        
        [self.servicePoint addMeterReadingsObject:reading];
        
        
        if (!self.servicePoint.meterReading.allocationBankAccount && self.servicePoint.allocationBankAccounts.count==1) {
            
            self.servicePoint.meterReading.allocationBankAccount = (AllocationBankAccount*)[self.servicePoint.allocationBankAccounts anyObject];
        }

        [delegate saveContext];

        
        [self displayDetails];
    }
}*/

@end
