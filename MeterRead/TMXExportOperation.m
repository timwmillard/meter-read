//
//  TMXExportOperation.m
//  MeterRead
//
//  Created by Tim Millard on 11/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXExportOperation.h"

@implementation TMXExportOperation

- (NSString *)getExportFileName
{
    return @"meter-readings.csv";
}

- (NSData *)exportToData
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ServicePoint"];
    
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[nameSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *servicePointsArray = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMetered==YES"];
    [fetchRequest setPredicate:predicate];
    
    NSOutputStream *outputStream = [NSOutputStream outputStreamToMemory];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:outputStream encoding:NSUTF8StringEncoding delimiter:','];
    
    // Service Point , Type ,Alloc Bank Account , Owner ,Previous Value ,Meter Reading  Time  Date ,Estimated Usage ,Expected Reading ,Service Point ,Meter Reading , Time , Date ,,NAME,ACCEPT,REASON,Latitude,Longitude
    NSArray *header = @[@"Service Point",
                        @"Type",
                        @"Alloc Bank Account",
                        @"Owner",
                        @"Previous Value",
                        @"Meter Reading  Time  Date",
                        @"Estimated Usage",
                        @"Expected Reading",
                        @"Service Point",
                        @"Meter Reading",
                        @"Time",
                        @"Date",
                        @"",
                        @"NAME",
                        @"ACCEPT",
                        @"REASON"];
    
    [writer writeLineOfFields:header];
    
    for (ServicePoint *servicePoint in servicePointsArray) {
        for (AllocationBankAccount *allocationBankAccount in servicePoint.allocationBankAccounts.allObjects) {
            
            
            [writer writeField:servicePoint.name];
            [writer writeField:servicePoint.type];
            [writer writeField:allocationBankAccount.name];
            [writer writeField:allocationBankAccount.owner];
            [writer writeField:servicePoint.prevMeterReading.readingString];
            [writer writeField:servicePoint.prevMeterReading.dateTimeString];
            [writer writeField:allocationBankAccount.estimatedUsage.stringValue];
            [writer writeField:servicePoint.expectedReadingString];
            [writer writeField:servicePoint.name];
            if (servicePoint.meterReading.allocationBankAccount==allocationBankAccount) {
                [writer writeField:servicePoint.meterReading.reading.stringValue];
                [writer writeField:servicePoint.meterReading.timeString];
                [writer writeField:servicePoint.meterReading.dateString];
                [writer writeField:@""];
                [writer writeField:servicePoint.meterReading.readBy];
                [writer writeField:@"YES"];
                [writer writeField:servicePoint.meterReading.comment];
                
                if (servicePoint.meterReading.reading != nil)
                    servicePoint.meterReading.hasBeenSent = @1;
            }else {
                [writer writeField:@""];
                [writer writeField:@""];
                [writer writeField:@""];
                [writer writeField:@""];
                [writer writeField:@""];
                [writer writeField:@""];
                [writer writeField:@""];
            }
            
            [writer finishLine];
        }
    }
    
    return [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

- (NSData *)exportToDataForServicePoint:(ServicePoint *)servicePoint
{
    NSOutputStream *outputStream = [NSOutputStream outputStreamToMemory];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:outputStream encoding:NSUTF8StringEncoding delimiter:','];
    
    // Service Point , Type ,Alloc Bank Account , Owner ,Previous Value ,Meter Reading  Time  Date ,Estimated Usage ,Expected Reading ,Service Point ,Meter Reading , Time , Date ,,NAME,ACCEPT,REASON,Latitude,Longitude
    NSArray *header = @[@"Service Point",
                        @"Type",
                        @"Alloc Bank Account",
                        @"Owner",
                        @"Previous Value",
                        @"Meter Reading  Time  Date",
                        @"Estimated Usage",
                        @"Expected Reading",
                        @"Service Point",
                        @"Meter Reading",
                        @"Time",
                        @"Date",
                        @"",
                        @"NAME",
                        @"ACCEPT",
                        @"REASON"];
    
    [writer writeLineOfFields:header];
    
    [writer writeField:servicePoint.name];
    [writer writeField:servicePoint.type];
    [writer writeField:servicePoint.meterReading.allocationBankAccount.name];
    [writer writeField:servicePoint.meterReading.allocationBankAccount.owner];
    [writer writeField:servicePoint.prevMeterReading.readingString];
    [writer writeField:servicePoint.prevMeterReading.dateTimeString];
    [writer writeField:servicePoint.meterReading.allocationBankAccount.estimatedUsage.stringValue];
    [writer writeField:servicePoint.expectedReadingString];
    [writer writeField:servicePoint.name];
    [writer writeField:servicePoint.meterReading.reading.stringValue];
    [writer writeField:servicePoint.meterReading.timeString];
    [writer writeField:servicePoint.meterReading.dateString];
    [writer writeField:@""];
    [writer writeField:servicePoint.meterReading.readBy];
    [writer writeField:@"YES"];
    [writer writeField:servicePoint.meterReading.comment];
    
    [writer finishLine];
    
    return [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

@end
