//
//  TMXMeterReadingHistoryViewController.m
//  MeterRead
//
//  Created by Tim Millard on 22/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXMeterReadingHistoryViewController.h"

#import "TMXMeterReadingHistoryCell.h"
#import "TMXAppDelegate.h"
#import "TMXMeterReadingDetailsViewController.h"

@interface TMXMeterReadingHistoryViewController ()

@end

@implementation TMXMeterReadingHistoryViewController
{
    NSMutableArray *_latestMeterReadings;
    MeterReading *_prevMeterReading;
    NSMutableArray *_historyMeterReadings;
    
    NSArray *_meterReadings;
}


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
	// Do any additional setup after loading the view.
    
    self.title = self.servicePoint.name;
    
    _latestMeterReadings = [self.servicePoint.latestMeterReadings mutableCopy];
    _prevMeterReading = self.servicePoint.prevMeterReading;
    _historyMeterReadings = [self.servicePoint.historyMeterReadings mutableCopy];
    
    NSSortDescriptor *dateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSArray *sortDescriptors = @[dateTimeDescriptor];
    _meterReadings = [self.servicePoint.meterReadings sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) // Latest Meter Readings
        return _latestMeterReadings.count;
    else if (section == 1) // Previous Meter Reading
        return 1;
    else if (section == 2)// History Meter Readings
        return _historyMeterReadings.count;
    else
        return _meterReadings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MeterReadingHistoryCell";
    TMXMeterReadingHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    MeterReading *meterReading;
    
    if (indexPath.section == 0 ) {
        meterReading = _latestMeterReadings[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];

    } else if (indexPath.section == 1 ) {
        meterReading = self.servicePoint.prevMeterReading; //_prevMeterReading;
        cell.backgroundColor = [UIColor whiteColor];
        
    } else if (indexPath.section == 2 ) {
        meterReading = _historyMeterReadings[indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    } else {
        meterReading = _meterReadings[indexPath.row];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    cell.meterReadingLabel.text = meterReading.readingString;
    cell.abaLabel.text = meterReading.allocationBankAccount.name;
    cell.dateTimeLabel.text = meterReading.dateTimeString;
    cell.commentLabel.text = meterReading.comment;
    
   // if (meterReading.isSystemReading) {
    //    cell.meterReadingLabel.textColor = [UIColor lightGrayColor];
   //     cell.dateTimeLabel.textColor = [UIColor lightGrayColor];
    //} else {
    //     cell.meterReadingLabel.textColor = [UIColor blackColor];
     //   cell.dateTimeLabel.textColor = [UIColor blueColor];
    //}
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
     if (indexPath.section==0)
        return YES;
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section==0) {
        MeterReading *meterReading = _latestMeterReadings[indexPath.row];
        [_latestMeterReadings removeObjectAtIndex:indexPath.row];
        [self.servicePoint removeMeterReadingsObject:meterReading];
        
        [delegate saveContext];
        
        [self.tableView reloadData];
        
        [self enterEditMode:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Latest Meter Readings";
    else if (section == 1)
        return @"Previous Meter Reading";
    else if (section == 2)
        return @"History";
    else
        return @"ALL";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMeterReadingDetailsView"]) {
        MeterReading *reading;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath.section == 0)
            reading = _latestMeterReadings[indexPath.row];
        else if (indexPath.section == 1)
            reading = _prevMeterReading;
        else if (indexPath.section == 2)
            reading = _historyMeterReadings[indexPath.row];
        else
            reading = _meterReadings[indexPath.row];

        TMXMeterReadingDetailsViewController *detailsController = [segue destinationViewController];
        detailsController.servicePoint = self.servicePoint;
        detailsController.meterReading = reading;
    }
}

- (IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Edit"];
    }
    else if (_latestMeterReadings.count>0) {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Done"];
        
        // Turn on edit mode
        
        [self.tableView setEditing:YES animated:YES];
    }
}

@end
