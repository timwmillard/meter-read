//
//  TMXAllocBankAccountViewController.m
//  MeterRead
//
//  Created by Tim Millard on 28/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXAllocBankAccountViewController.h"

#import "TMXAppDelegate.h"
#import "TMXSelectABACell.h"

@interface TMXAllocBankAccountViewController ()

@end

@implementation TMXAllocBankAccountViewController
{
    NSArray *_allocBankAccounts;
    NSIndexPath *_prevIndexPath;
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
    
    _allocBankAccounts = self.servicePoint.allocationBankAccounts.allObjects;
}

- (void)viewDidAppear:(BOOL)animated
{
    MeterReading *meterReading = self.servicePoint.meterReading;
    
    // Set selection to ABA
    NSIndexPath *index = nil;

    for (int row=0; row<_allocBankAccounts.count; row++) {
        if (meterReading.allocationBankAccount==_allocBankAccounts[row]) {
            index = [NSIndexPath indexPathForRow:row inSection:0];
            break;
        }
    }
    if (index) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _prevIndexPath = index;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
  //  if (!self.servicePoint.meterReading) {
    //    MeterReading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
      //                                                                inManagedObjectContext:delegate.managedObjectContext];
    //    [self.servicePoint addMeterReadingsObject:reading];
    //}
    
    //int row = self.tableView.indexPathForSelectedRow.row;
    NSInteger row = [[self indexPathForCheckedCell] row];
    self.servicePoint.meterReading.allocationBankAccount = _allocBankAccounts[row];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _allocBankAccounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AllocBankAccountCell";
    TMXSelectABACell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    AllocationBankAccount *aba = _allocBankAccounts[indexPath.row];
    cell.abaLabel.text = aba.name;
    cell.ownerLabel.text = aba.owner;
    cell.estimatedUsageLabel.text = [NSString stringWithFormat:@"%@ ML", aba.estimatedUsage];
    
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView reloadData];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath isEqual:_prevIndexPath])
        return;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *prevCell =  [tableView cellForRowAtIndexPath:_prevIndexPath];
    prevCell.accessoryType = UITableViewCellAccessoryNone;
    
    _prevIndexPath = indexPath;
}

- (NSIndexPath *)indexPathForCheckedCell
{
    for (int i=0; i < [self.tableView numberOfRowsInSection:0]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
            return indexPath;
    }
    return nil;
}

@end
