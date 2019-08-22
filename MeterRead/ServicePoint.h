//
//  ServicePoint.h
//  MeterRead
//
//  Created by Tim Millard on 16/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern int const kMeterReadingTolerance;
extern int const kNumberDecimalPlaces;

@class AllocationBankAccount, MeterReading, Section;

@interface ServicePoint : NSManagedObject

@property (nonatomic, retain) NSString * channelName;
@property (nonatomic) BOOL isMetered;
@property (nonatomic, retain) NSDate * lastImport;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *allocationBankAccounts;
@property (nonatomic, retain) NSSet *meterReadings;
@property (nonatomic, retain) Section *section;

@property (nonatomic, readonly) MeterReading *meterReading;
@property (nonatomic, readonly) MeterReading *prevMeterReading;
@property (nonatomic, readonly) NSArray *latestMeterReadings;
@property (nonatomic, readonly) NSArray *historyMeterReadings;

@property (nonatomic, readonly) NSNumber *actualUsage;
@property (nonatomic, readonly) NSString *actualUsageString;

// Expected Reading should be based per Allocation Bank Account NOT Service Point
@property (nonatomic, readonly) NSNumber *expectedReading;
@property (nonatomic, readonly) NSString *expectedReadingString;
@property (nonatomic, readonly, getter = isDomesticStock) BOOL domesticStock;

@property (nonatomic, readonly) BOOL validLocation;

+ (NSString *)formatNumber:(NSNumber *)number;

- (NSNumber *)actualUsageForReading:(NSNumber *)meterReading;
- (NSString *)actualUsageStringForReading:(NSNumber *)meterReading;
- (BOOL)meterReadingIsWithinTolerenceForReading:(NSNumber *)meterReading;
- (BOOL)meterReadingIsWithinTolerence;
- (BOOL)meterReadingIsCompleted;
- (MeterReading *)addNewMeterReading;
- (MeterReading *)addSystemMeterReading:(NSNumber *)reading withDateTime:(NSDate *)dateTime;
- (AllocationBankAccount *)addNewAllocationAccount:(NSString *)name;

@end

@interface ServicePoint (CoreDataGeneratedAccessors)

- (void)addAllocationBankAccountsObject:(AllocationBankAccount *)value;
- (void)removeAllocationBankAccountsObject:(AllocationBankAccount *)value;
- (void)addAllocationBankAccounts:(NSSet *)values;
- (void)removeAllocationBankAccounts:(NSSet *)values;

- (void)addMeterReadingsObject:(MeterReading *)value;
- (void)removeMeterReadingsObject:(MeterReading *)value;
- (void)addMeterReadings:(NSSet *)values;
- (void)removeMeterReadings:(NSSet *)values;

@end
