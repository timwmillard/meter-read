//
//  TMXDetailsViewController.h
//  MeterRead
//
//  Created by Tim Millard on 24/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "ServicePoint.h"
#import "MeterReading.h"
#import "AllocationBankAccount.h"

@interface TMXDetailsViewController : UITableViewController
                                      <UIActionSheetDelegate,
                                       MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) ServicePoint *servicePoint;

@property (weak, nonatomic) IBOutlet UILabel *servicePointLabel;
@property (weak, nonatomic) IBOutlet UILabel *abaLabel;
@property (weak, nonatomic) IBOutlet UILabel *meterReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *abaHeadingLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)showActionMenu:(id)sender;
- (IBAction)addNewMeterReading:(id)sender;

@end
