//
//  TMXSettingsViewController.h
//  MeterRead
//
//  Created by Tim Millard on 27/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMXSettingsViewController : UITableViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *readByLabel;

- (IBAction)clearAll:(id)sender;

@end
