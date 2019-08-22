//
//  TMXReadByViewController.m
//  MeterRead
//
//  Created by Tim Millard on 28/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXReadByViewController.h"

@interface TMXReadByViewController ()

@end

@implementation TMXReadByViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.readByTextField becomeFirstResponder];
    
    NSString *readBy = [[NSUserDefaults standardUserDefaults] stringForKey:@"readBy"];
    
    self.readByTextField.text = readBy;
}

- (IBAction)save:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *readBy = self.readByTextField.text;
    
    [defaults setObject:readBy forKey:@"readBy"];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
