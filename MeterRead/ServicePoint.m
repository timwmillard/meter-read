//
//  ServicePoint.m
//  MeterRead
//
//  Created by Tim Millard on 16/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "ServicePoint.h"
#import "AllocationBankAccount.h"
#import "MeterReading.h"
#import "Section.h"

int const kMeterReadingTolerance = 20;
int const kNumberDecimalPlaces = 3;

@implementation ServicePoint

@dynamic channelName;
@dynamic isMetered;
@dynamic lastImport;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic type;
@dynamic allocationBankAccounts;
@dynamic meterReadings;
@dynamic section;

+ (NSString *)formatNumber:(NSNumber *)number
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:kNumberDecimalPlaces];
    [numberFormatter setPerMillSymbol:@""];
    [numberFormatter setUsesGroupingSeparator:NO];
    return [numberFormatter stringFromNumber:number];
}

- (MeterReading*)meterReading
{
    NSSortDescriptor *dateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSArray *sortDescriptors = @[dateTimeDescriptor];
    NSArray *readings = [self.meterReadings sortedArrayUsingDescriptors:sortDescriptors];
    
    if (readings.count<1)
        return [self addNewMeterReading];

    // Return new meter reading
    MeterReading *lastReading = readings[readings.count-1];
    if (lastReading.dateTime==nil && !lastReading.isSystemReading)
        return lastReading;
 
    MeterReading *reading = readings[0];
    
    if (reading.isSystemReading)
        return [self addNewMeterReading];
    
    return reading;
}

- (MeterReading*)prevMeterReading
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSystemReading == YES"];
    
    NSSet *systemOnly = [self.meterReadings filteredSetUsingPredicate:predicate];
    
    NSSortDescriptor *dateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSArray *sortDescriptors = @[dateTimeDescriptor];
    NSArray *readings = [systemOnly sortedArrayUsingDescriptors:sortDescriptors];
    
    if (readings.count>0)
    
        return readings[0];
    else
        return nil;
}

- (NSArray*)latestMeterReadings
{
    NSDate *prevDate = self.prevMeterReading.dateTime;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateTime > %@", prevDate];
    
    NSSet *latest = [self.meterReadings filteredSetUsingPredicate:predicate];
    
    NSSortDescriptor *dateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSArray *sortDescriptors = @[dateTimeDescriptor];
    NSArray *readings = [latest sortedArrayUsingDescriptors:sortDescriptors];
    
    return readings;
}

- (NSArray*)historyMeterReadings
{
    NSDate *prevDate = self.prevMeterReading.dateTime;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateTime < %@", prevDate];
    
    NSSet *oldest = [self.meterReadings filteredSetUsingPredicate:predicate];
    
    NSSortDescriptor *dateTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO];
    NSArray *sortDescriptors = @[dateTimeDescriptor];
    NSArray *readings = [oldest sortedArrayUsingDescriptors:sortDescriptors];
    
    return readings;
}

- (NSNumber*)actualUsage
{
    if (!self.meterReading.reading || !self.prevMeterReading.reading)
        return nil;
    
    double usage = self.meterReading.reading.doubleValue - self.prevMeterReading.reading.doubleValue;
    return [NSNumber numberWithDouble:usage];
}

- (NSString*)actualUsageString
{
    return [ServicePoint formatNumber:self.actualUsage];
}

- (NSNumber*)expectedReading
{
    if (!self.meterReading.allocationBankAccount.estimatedUsage || !self.prevMeterReading.reading)
        return nil;
    
    double expected = self.prevMeterReading.reading.doubleValue + self.meterReading.allocationBankAccount.estimatedUsage.doubleValue;
    return [NSNumber numberWithDouble:expected];
}

- (NSString*)expectedReadingString
{
    return [ServicePoint formatNumber:self.expectedReading];
}

- (BOOL)isDomesticStock
{
    return [self.type isEqualToString:@"PPM"];
}

- (BOOL)validLocation
{
    return (self.latitude.doubleValue!=0 && self.longitude.doubleValue!=0);
}

- (NSNumber *)actualUsageForReading:(NSNumber *)meterReading
{;
    double currentMeterReading = meterReading.doubleValue;
    double prevMeterReading = self.prevMeterReading.reading.doubleValue;
    double actualUsage = currentMeterReading - prevMeterReading;
    return [NSNumber numberWithDouble:actualUsage];
}

- (NSString *)actualUsageStringForReading:(NSNumber *)meterReading
{
    return [ServicePoint formatNumber:[self actualUsageForReading:meterReading]];
}

- (BOOL)meterReadingIsWithinTolerenceForReading:(NSNumber *)meterReading
{
    double estUsage = self.meterReading.allocationBankAccount.estimatedUsage.doubleValue;
    double actualUsage = [self actualUsageForReading:meterReading].doubleValue;
    
    if ([self isDomesticStock])
        return (actualUsage >= 0);
    
    if (estUsage==0)
        return !actualUsage;
    
    double error = actualUsage/estUsage;
    
    return (error > 0.8 && error < 1.2);
}

- (BOOL)meterReadingIsWithinTolerence
{
    return [self meterReadingIsWithinTolerenceForReading:self.meterReading.reading];
}

- (BOOL)meterReadingIsCompleted
{
    BOOL isWithinTolerance = [self meterReadingIsWithinTolerence];
    return (self.meterReading && isWithinTolerance) ||
            (!isWithinTolerance && self.meterReading.comment.length);
}

- (MeterReading *)addNewMeterReading
{
    MeterReading *reading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
                                                          inManagedObjectContext:self.managedObjectContext];
    
    // Check for single ABA
    if (self.allocationBankAccounts.count==1) {
        reading.allocationBankAccount = (AllocationBankAccount*)[self.allocationBankAccounts anyObject];
    }
    
    [self addMeterReadingsObject:reading];
    
    return reading;
}

- (MeterReading *)addSystemMeterReading:(NSNumber *)reading withDateTime:(NSDate *)dateTime
{
    // Check for valid reading and dateTime
    if (!reading || !dateTime)
        return nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateTime == %@ && isSystemReading == YES", dateTime];
    MeterReading *duplicateReading = [[self.meterReadings filteredSetUsingPredicate:predicate] anyObject];
    
    if (duplicateReading) {
        duplicateReading.reading = reading;
        [self addMeterReadingsObject: duplicateReading];
        return duplicateReading;
    }
    
    MeterReading *aReading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
                                                          inManagedObjectContext:self.managedObjectContext];
    aReading.reading = reading;
    aReading.dateTime = dateTime;
    aReading.isSystemReading = YES;
    
    [self addMeterReadingsObject:aReading];
    return  aReading;
}

- (AllocationBankAccount *)addNewAllocationAccount:(NSString *)name
{
    return nil;
}

@end
