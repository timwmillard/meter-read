//
//  TMXAppDelegate.h
//  MeterRead
//
//  Created by Tim Millard on 20/04/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) NSOperationQueue *backgroundQueue;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)deleteAllObjectsFromEntity:(NSString *)entityDescription;

@end
