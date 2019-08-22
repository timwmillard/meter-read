//
//  TMXMeterReadingsFile.h
//  MeterRead
//
//  Created by Tim Millard on 6/05/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//
/*
#import <Foundation/Foundation.h>

#import "CHCSVParser.h"

#import "TMXAppDelegate.h"
#import "ServicePoint.h"
#import "AllocationBankAccount.h"
#import "MeterReading.h"


@interface TMXMeterReadingsFile : NSObject <CHCSVParserDelegate>

- (NSString *)getExportFileName;
- (NSData *)exportToData;
- (NSData *)exportToDataForServicePoint:(ServicePoint *)servicePoint;
- (BOOL)importFromURL:(NSURL *)url;

// CHCSVParserDelegate Methods
- (void)parserDidBeginDocument:(CHCSVParser *)parser;
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber;
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex;
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber;
- (void)parserDidEndDocument:(CHCSVParser *)parser;
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error;


@end
*/