//
//  TMXImportOperation.m
//  MeterRead
//
//  Created by Tim Millard on 11/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXImportOperation.h"

#import "Group.h"

@implementation TMXImportOperation
{
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
    NSDate *_lastImport;
    
    Group *_importGroup;
}

@synthesize url = _url;
@synthesize sharedPersistentStoreCoordinator = _sharedPersistentStoreCoordinator;

- (id)initWithURL:(NSURL *)url sharedPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)psc
{
    self = [super init];
    
    if (self) {
        _url = url;
        _sharedPersistentStoreCoordinator = psc;
        
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

// The main function for this NSOperation, to start the parsing.
- (void)main
{
    @autoreleasepool {
        
        // Creating context in main function here make sure the context is tied to current thread.
        // init: use thread confine model to make things simpler.
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = self.sharedPersistentStoreCoordinator;
        //self.managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        [self setupLastImport];
        
        NSStringEncoding encoding = 0;
        NSInputStream *stream = [NSInputStream inputStreamWithURL:self.url];
        
        CHCSVParser *parser = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
        parser.recognizesBackslashesAsEscapes = YES;
        parser.sanitizesFields = YES;
        parser.stripsLeadingAndTrailingWhitespace = YES;
        CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding));
        parser.delegate = self;
        
        [parser parse];
    }

}

- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
    _lines = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    
    _currentLine = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    //NSLog(@"%@", field);
    [_currentLine addObject:field];
}
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    
    // Header
    if (recordNumber==1) {
        [self headerLine];
    } else {
        [self addServicePointToList];
    }
    
    
    [_lines addObject:_currentLine];
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser
{
    
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges]) {
        
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful
            // during development. If it is not possible to recover from the error, display an alert
            // panel that instructs the user to quit the application by pressing the Home button.
            //
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }
    
    error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager removeItemAtURL:self.url error:&error]) {
        
        NSLog(@"Unable to delete file %@, %@", error, [error userInfo]);
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
	NSLog(@"ERROR: %@", error);
    _lines = nil;
}

// Service Point , Type ,Alloc Bank Account , Owner ,Previous Value ,Meter Reading  Time  Date ,Estimated Usage ,Expected Reading ,Service Point ,Meter Reading , Time , Date ,,NAME,ACCEPT,REASON,Latitude,Longitude
- (void)headerLine
{
    int colNum = 0;
    int isMeterReadingFileCount = 0;
    for (NSString *headingName in _currentLine) {
        
        
        if (_servcePointTypeColNum == -1 && [headingName isEqualToString:@"Service Point"]) {
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
    
    _isMeterReadingFile = isMeterReadingFileCount >= 3;
}

- (void)addServicePointToList
{
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
    if (_isMeterReadingFile && abaName.length == 0) {
        if (servicePointName.length == 0)
            _channelName = servicePointType;
        else
            _channelName = servicePointName;
        
        return;
    }
    
    // Only create one service point
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ServicePoint"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", servicePointName];
    [request setPredicate:predicate];
    ServicePoint *servicePoint = [[self.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    
    
    ///// Service Point //////
    if (!servicePoint) {
        // Create a new ServicePoint
        servicePoint = [NSEntityDescription insertNewObjectForEntityForName:@"ServicePoint"
                                                     inManagedObjectContext:self.managedObjectContext];
        servicePoint.name = servicePointName;
    }
    
    servicePoint.lastImport = _lastImport;
    
    if (servicePointType.length)
        servicePoint.type = servicePointType;
    
    if (_channelName.length)
        servicePoint.channelName = _channelName;
    
    if (latitudeString.length && longitudeString.length) {
        servicePoint.latitude = [NSNumber numberWithDouble:latitudeString.doubleValue];
        servicePoint.longitude = [NSNumber numberWithDouble:longitudeString.doubleValue];
    }
    
    if (_isMeterReadingFile)
        servicePoint.isMetered = YES;
    
    
    ///// Allocation Bank Account //////
    if (_allocBankAccountColNum >= 0) {
        request = [NSFetchRequest fetchRequestWithEntityName:@"AllocationBankAccount"];
        predicate = [NSPredicate predicateWithFormat:@"name==%@ AND servicePoint.name==%@", abaName, servicePointName];
        [request setPredicate:predicate];
        
        AllocationBankAccount *allocBankAccount = [[self.managedObjectContext executeFetchRequest:request error:nil] lastObject];
        
        if (!allocBankAccount) {
            allocBankAccount = [NSEntityDescription insertNewObjectForEntityForName:@"AllocationBankAccount"
                                                             inManagedObjectContext:self.managedObjectContext];
            
            allocBankAccount.name = abaName;
            [servicePoint addAllocationBankAccountsObject:allocBankAccount];
        }
        
        if (abaOwner.length) allocBankAccount.owner = abaOwner;
        allocBankAccount.estimatedUsage = estimatedUsage;
    }
    
    ///// Prev Meter Reading //////
    [servicePoint addSystemMeterReading:prevReading withDateTime:prevDateTime];
}

- (void)setupLastImport
{
    _lastImport = [NSDate date];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_lastImport forKey:@"lastImport"];
    
    [defaults synchronize];
    
    _importGroup = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                                           inManagedObjectContext:self.managedObjectContext];
    
    _importGroup.name = [[self.url path] lastPathComponent]; //[NSString stringWithFormat:@"%@", _lastImport];
    _importGroup.importDateTime = _lastImport;
}

@end
