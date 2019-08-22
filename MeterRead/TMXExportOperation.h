//
//  TMXExportOperation.h
//  MeterRead
//
//  Created by Tim Millard on 11/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CHCSVParser.h"

#import "TMXAppDelegate.h"
#import "ServicePoint.h"
#import "AllocationBankAccount.h"
#import "MeterReading.h"

@interface TMXExportOperation : NSObject <CHCSVParserDelegate> // NSOperation

- (NSString *)getExportFileName;
- (NSData *)exportToData;
- (NSData *)exportToDataForServicePoint:(ServicePoint *)servicePoint;

@end
