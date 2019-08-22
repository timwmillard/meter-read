//
//  AllocBankAccount.h
//  MeterRead
//
//  Created by Tim Millard on 16/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MeterReading, ServicePoint;

@interface AllocationBankAccount : NSManagedObject

@property (nonatomic, retain) NSNumber * estimatedUsage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) MeterReading *meterReading;
@property (nonatomic, retain) ServicePoint *servicePoint;

@end
