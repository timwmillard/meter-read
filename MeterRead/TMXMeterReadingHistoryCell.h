//
//  TMXMeterReadingHistoryCell.h
//  MeterRead
//
//  Created by Tim Millard on 5/08/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMXMeterReadingHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *meterReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *abaLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
