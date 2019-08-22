//
//  TMXCommentViewController.h
//  MeterRead
//
//  Created by Tim Millard on 26/05/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServicePoint.h"
#import "MeterReading.h"

@interface TMXCommentViewController : UITableViewController

@property (strong, nonatomic) ServicePoint *servicePoint;

@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *autoFillButton1;
@property (weak, nonatomic) IBOutlet UIButton *autoFillButton2;
@property (weak, nonatomic) IBOutlet UIButton *autoFillButton3;
@property (weak, nonatomic) IBOutlet UIButton *autoFillButton4;

- (IBAction)autoFillComment:(id)sender;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
