//
//  Group.m
//  MeterRead
//
//  Created by Tim Millard on 15/06/14.
//  Copyright (c) 2014 Timix Technology. All rights reserved.
//

#import "Group.h"
#import "ServicePoint.h"


@implementation Group

@dynamic name;
@dynamic importDateTime;
@dynamic importCount;
@dynamic servicePoints;

- (NSString*)importDateTimeString
{
    //yyyy-MM-dd 'at' HH:mm
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
    return  [dateFormatter stringFromDate:self.importDateTime];
}

@end
