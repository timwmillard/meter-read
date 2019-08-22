//
//  TMXSelectABACell.h
//  MeterRead
//
//  Created by Tim Millard on 4/08/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMXSelectABACell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *abaLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedUsageLabel;

@end
