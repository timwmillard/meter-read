//
//  Section.h
//  MeterRead
//
//  Created by Tim Millard on 16/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ServicePoint;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSNumber * display;
@property (nonatomic, retain) NSDate * lastImport;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *servicePoints;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addServicePointsObject:(ServicePoint *)value;
- (void)removeServicePointsObject:(ServicePoint *)value;
- (void)addServicePoints:(NSSet *)values;
- (void)removeServicePoints:(NSSet *)values;

@end
