//
//  TMXSettingsViewController.m
//  MeterRead
//
//  Created by Tim Millard on 27/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXSettingsViewController.h"

#import "TMXAppDelegate.h"

@interface TMXSettingsViewController ()

@end

@implementation TMXSettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *readBy = [[NSUserDefaults standardUserDefaults] stringForKey:@"readBy"];
    self.readByLabel.text = readBy;

   [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clearAll:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to clear all service points and meter readings?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Clear All"
                                               otherButtonTitles:nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self clearAllMeterReadingsAndSevicePoints];
    }
    
}

-(void)clearAllMeterReadingsAndSevicePoints
{
    
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate deleteAllObjectsFromEntity:@"ServicePoint"];
    [delegate deleteAllObjectsFromEntity:@"AllocationBankAccount"];
    [delegate deleteAllObjectsFromEntity:@"MeterReading"];
    [delegate deleteAllObjectsFromEntity:@"Section"];
    
}

@end
