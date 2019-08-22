//
//  MeterReading.h
//  MeterRead
//
//  Created by Tim Millard on 23/05/14.
//  Copyright (c) 2014 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllocationBankAccount, ServicePoint;

@interface MeterReading : NSManagedObject

@property (nonatomic, retain) NSNumber * acceptValue;
@property (nonatomic) BOOL isSystemReading;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * dateTimeEntered;
@property (nonatomic, retain) NSNumber * hasBeenSent;
@property (nonatomic, retain) NSString * readBy;
@property (nonatomic, retain) NSNumber * reading;
@property (nonatomic, retain) AllocationBankAccount *allocationBankAccount;
@property (nonatomic, retain) ServicePoint *servicePoint;

@property (nonatomic, readonly) NSString *readingString;
@property (nonatomic, readonly) NSString *dateTimeString;
@property (nonatomic, readonly) NSString *dateString;
@property (nonatomic, readonly) NSString *timeString;

@end
