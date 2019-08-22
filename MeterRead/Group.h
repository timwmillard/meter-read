//
//  Group.h
//  MeterRead
//
//  Created by Tim Millard on 15/06/14.
//  Copyright (c) 2014 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ServicePoint;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * importDateTime;
@property (nonatomic, retain) NSNumber * importCount;
@property (nonatomic, retain) NSSet *servicePoints;

- (NSString*)importDateTimeString;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addServicePointsObject:(ServicePoint *)value;
- (void)removeServicePointsObject:(ServicePoint *)value;
- (void)addServicePoints:(NSSet *)values;
- (void)removeServicePoints:(NSSet *)values;

@end
