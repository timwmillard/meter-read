//
//  DataController.h
//  MeterRead
//
//  Created by Tim Millard on 22/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(id)sharedInstance;
- (void)saveContext;
- (void)deleteAllObjectsFromEntity:(NSString *)entityDescription;
- (NSURL *)applicationDocumentsDirectory;

@end
