//
//  TMXImportViewController.m
//  MeterRead
//
//  Created by Tim Millard on 19/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXImportViewController.h"

@interface TMXImportViewController ()

@end

@implementation TMXImportViewController
{
    NSIndexPath *_prevIndexPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ImportSectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
 
    if (indexPath.section == 0 ) {
        cell.textLabel.text = @"Create a New Section";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    } else {
        cell.textLabel.text = @"T5";
        cell.detailTextLabel.text = @"Torrumbarry Section 5";
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"";
    else
        return @"Choose a section:";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView reloadData];
    if (indexPath.section == 0)
        return;
    
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

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
