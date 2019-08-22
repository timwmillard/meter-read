//
//  TMXMeterReadingsFile.m
//  MeterRead
//
//  Created by Tim Millard on 6/05/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//
/*
#import "TMXMeterReadingsFile.h"


@implementation TMXMeterReadingsFile {
    NSMutableArray *_lines;
    NSMutableArray *_currentLine;
    
    NSString *_channelName;
    
    // Service Point , Type ,Alloc Bank Account , Owner ,Previous Value ,Meter Reading  Time  Date ,Estimated Usage ,Expected Reading ,Service Point ,Meter Reading , Time , Date ,,NAME,ACCEPT,REASON,Latitude,Longitude
    int _servicePointNameColNum,
    _servcePointTypeColNum,
    _allocBankAccountColNum,
    _ownerColNum,
    _prevDateTimeColNum,
    _prevReadingColNum,
    _estimatedUsageColNum,
    _meterReadingColNum,
    _latitudeColNum,
    _longitudeColNum;
    
    BOOL _isMeterReadingFile;
}

- (id)init
{
    self = [super init];
    if (self) {
        _channelName = @"";
        
        _servcePointTypeColNum = -1;
        _servcePointTypeColNum = -1;
        _allocBankAccountColNum = -1;
        _ownerColNum = -1;
        _prevReadingColNum = -1;
        _prevDateTimeColNum = -1;
        _estimatedUsageColNum = -1;
        _meterReadingColNum = -1;
        _latitudeColNum = -1;
        _longitudeColNum = -1;
        
        _isMeterReadingFile = NO;
    }
    return self;
}

- (NSString *)getExportFileName
{
    return @"meter-readings.csv";
}

- (NSData *)exportToData
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ServicePoint"];
    
    NSArray *servicePointsArray = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSString *userName = [[UIDevice currentDevice] name];
    
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
                [writer writeField:userName];
                [writer writeField:@"YES"];
                [writer writeField:servicePoint.meterReading.comment];
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
 
    NSString *userName = [[UIDevice currentDevice] name];
    
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
    [writer writeField:userName];
    [writer writeField:@"YES"];
    [writer writeField:servicePoint.meterReading.comment];
        
    [writer finishLine];
   
    return [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

- (BOOL)importFromURL:(NSURL *)url
{
    @autoreleasepool {
        
        NSStringEncoding encoding = 0;
        NSInputStream *stream = [NSInputStream inputStreamWithURL:url];
        
        CHCSVParser *parser = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
        parser.recognizesBackslashesAsEscapes = YES;
        parser.sanitizesFields = YES;
        parser.stripsLeadingAndTrailingWhitespace = YES;
        CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding));
        parser.delegate = self;
        
        [parser parse];
    }
    
    return YES;
}

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    _lines = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    
    _currentLine = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    //NSLog(@"%@", field);
    [_currentLine addObject:field];
}
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    
    // Header
    if (recordNumber==1) {
        [self headerLine];
    } else {
        [self addLineToCoreData];
    }
    
    
    [_lines addObject:_currentLine];
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    //	NSLog(@"parser ended: %@", csvFile);
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"ERROR: %@", error);
    _lines = nil;
}

// Service Point , Type ,Alloc Bank Account , Owner ,Previous Value ,Meter Reading  Time  Date ,Estimated Usage ,Expected Reading ,Service Point ,Meter Reading , Time , Date ,,NAME,ACCEPT,REASON,Latitude,Longitude
- (void)headerLine
{
    int colNum = 0;
    int isMeterReadingFileCount = 0;
    for (NSString *headingName in _currentLine) {
        
        
        if ([headingName isEqualToString:@"Service Point"]) {
            _servicePointNameColNum = colNum;
            isMeterReadingFileCount++;
        } else if ([headingName isEqualToString:@"Type"]) {
            _servcePointTypeColNum = colNum;
        } else if ([headingName isEqualToString:@"Alloc Bank Account"]) {
            _allocBankAccountColNum = colNum;
            isMeterReadingFileCount++;
        } else if ([headingName isEqualToString:@"Owner"]) {
            _ownerColNum = colNum;
        } else if ([headingName isEqualToString:@"Previous Value"]) {
            _prevReadingColNum = colNum;
        } else if ([headingName isEqualToString:@"Meter Reading  Time  Date"]) {
            _prevDateTimeColNum = colNum;
        } else if ([headingName isEqualToString:@"Estimated Usage"]) {
            _estimatedUsageColNum = colNum;
        } else if ([headingName isEqualToString:@"Meter Reading"]) {
            _meterReadingColNum = colNum;
            isMeterReadingFileCount++;
        } else if ([headingName isEqualToString:@"Latitude"]) {
            _latitudeColNum = colNum;
        } else if ([headingName isEqualToString:@"Longitude"]) {
            _longitudeColNum = colNum;
        }
        
        colNum++;
    }
    if (isMeterReadingFileCount >= 3)
        _isMeterReadingFile = YES;
}

- (void)addLineToCoreData
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    // Formatters
    NSNumberFormatter *decimalFormatt = [[NSNumberFormatter alloc] init];
    [decimalFormatt setNumberStyle:NSNumberFormatterDecimalStyle];
    NSDateFormatter *dateFormatt = [[NSDateFormatter alloc] init];
    [dateFormatt setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSString *servicePointName = @"";
    NSString *servicePointType = @"";
    NSString *abaName = @"";
    NSString *abaOwner = @"";
    NSString *prevReadingString = @"";
    NSString *prevDateTimeString = @"";
    NSString *estimatedUsageString = @"";
    NSString *latitudeString = @"";
    NSString *longitudeString = @"";
    
    int colCount = _currentLine.count;
    if (_servicePointNameColNum >= 0 && _servicePointNameColNum < colCount)
        servicePointName = _currentLine[_servicePointNameColNum];
    else
        return;
    
    if (_servcePointTypeColNum >= 0 && _servcePointTypeColNum < colCount)
        servicePointType = _currentLine[_servcePointTypeColNum];
    
    if (_allocBankAccountColNum >= 0 && _allocBankAccountColNum < colCount)
        abaName = _currentLine[_allocBankAccountColNum];
    
    if (_ownerColNum >= 0 && _ownerColNum < colCount)
        abaOwner = _currentLine[_ownerColNum];
    
    if (_prevReadingColNum >= 0 && _prevReadingColNum < colCount)
        prevReadingString = _currentLine[_prevReadingColNum];
    
    if (_prevDateTimeColNum >= 0 && _prevDateTimeColNum < colCount)
        prevDateTimeString = _currentLine[_prevDateTimeColNum];
    
    if (_estimatedUsageColNum >= 0 && _estimatedUsageColNum < colCount)
        estimatedUsageString = _currentLine[_estimatedUsageColNum];
    
    if (_latitudeColNum >= 0 && _latitudeColNum < colCount)
        latitudeString = _currentLine[_latitudeColNum];
    
    //13 < 14
    if (_longitudeColNum >= 0 && _longitudeColNum < colCount)
        longitudeString = _currentLine[_longitudeColNum];
    
    
    NSNumber *prevReading = [decimalFormatt numberFromString:prevReadingString];
    NSDate *prevDateTime = [dateFormatt dateFromString:prevDateTimeString];
    NSNumber *estimatedUsage = [decimalFormatt numberFromString:estimatedUsageString];
    
    
    // Check if line is a channel name
    if (_isMeterReadingFile && !abaName.length) {
        if (servicePointName.length)
            _channelName = servicePointName;
        else
            _channelName = servicePointType;
        
        return;
    }
    
    // Only create one service request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ServicePoint"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", servicePointName];
    [request setPredicate:predicate];
    ServicePoint *servicePoint = [[delegate.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    
    
    ///// Service Point //////
    if (!servicePoint) {
        // Create a new ServicePoint
        servicePoint = [NSEntityDescription insertNewObjectForEntityForName:@"ServicePoint"
                                                     inManagedObjectContext:delegate.managedObjectContext];
        servicePoint.name = servicePointName;
    }
    
    if (servicePointType.length)
        servicePoint.type = servicePointType;
    
    servicePoint.channelName = _channelName;
    
    if (latitudeString.length && longitudeString.length) {
        servicePoint.latitude = [NSNumber numberWithDouble:latitudeString.doubleValue];
        servicePoint.longitude = [NSNumber numberWithDouble:longitudeString.doubleValue];
    }
    
    if (_isMeterReadingFile)
        servicePoint.isMetered = YES;
    
    
    ///// Allocation Bank Account //////
    if (_allocBankAccountColNum >= 0) {
        request = [NSFetchRequest fetchRequestWithEntityName:@"AllocBankAccount"];
        predicate = [NSPredicate predicateWithFormat:@"name==%@ AND servicePoint.name==%@", abaName, servicePointName];
        [request setPredicate:predicate];
    
        AllocationBankAccount *allocationBankAccount = [[delegate.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    
        if (!allocationBankAccount) {
            allocationBankAccount = [NSEntityDescription insertNewObjectForEntityForName:@"AllocBankAccount"
                                                         inManagedObjectContext:delegate.managedObjectContext];
        
            allocationBankAccount.name = abaName;
            [servicePoint addAllocationBankAccountsObject:allocationBankAccount];
        }
    
        if (abaOwner.length) allocationBankAccount.owner = abaOwner;
        allocationBankAccount.estimatedUsage = estimatedUsage;
    }
    
    ///// Prev Meter Reading //////
    if (prevReadingString.length) {
        MeterReading *prevMeterReading = [NSEntityDescription insertNewObjectForEntityForName:@"MeterReading"
                                                                       inManagedObjectContext:delegate.managedObjectContext];
        prevMeterReading.reading = prevReading;
        prevMeterReading.dateTime = prevDateTime;
        
        //servicePoint.prevMeterReading = prevMeterReading;
        [servicePoint addMeterReadingsObject:prevMeterReading];
    }
}

@end
*/
