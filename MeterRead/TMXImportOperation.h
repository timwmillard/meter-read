//
//  TMXImportOperation.h
//  MeterRead
//
//  Created by Tim Millard on 11/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CHCSVParser.h"

#import "ServicePoint.h"
#import "AllocationBankAccount.h"
#import "MeterReading.h"

@interface TMXImportOperation : NSOperation <CHCSVParserDelegate>

@property (strong, readonly) NSURL *url;
@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly) NSPersistentStoreCoordinator *sharedPersistentStoreCoordinator;


- (id)initWithURL:(NSURL *)url sharedPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)psc;

// CHCSVParserDelegate Methods
- (void)parserDidBeginDocument:(CHCSVParser *)parser;
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber;
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex;
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber;
- (void)parserDidEndDocument:(CHCSVParser *)parser;
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error;

@end
