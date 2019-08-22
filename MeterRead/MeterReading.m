//
//  MeterReading.m
//  MeterRead
//
//  Created by Tim Millard on 16/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "MeterReading.h"
#import "AllocationBankAccount.h"
#import "ServicePoint.h"


@implementation MeterReading

@dynamic acceptValue;
@dynamic isSystemReading;
@dynamic comment;
@dynamic dateTime;
@dynamic dateTimeEntered;
@dynamic hasBeenSent;
@dynamic readBy;
@dynamic reading;
@dynamic allocationBankAccount;
@dynamic servicePoint;

-(NSString*)readingString
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:3];
    [numberFormatter setPerMillSymbol:@""];
    [numberFormatter setUsesGroupingSeparator:NO];
    return [numberFormatter stringFromNumber:self.reading];
}

-(NSString*)dateTimeString
{
    //yyyy-MM-dd 'at' HH:mm
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
    return  [dateFormatter stringFromDate:self.dateTime];
}

-(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return  [dateFormatter stringFromDate:self.dateTime];
}

-(NSString*)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return  [dateFormatter stringFromDate:self.dateTime];
}

@end
