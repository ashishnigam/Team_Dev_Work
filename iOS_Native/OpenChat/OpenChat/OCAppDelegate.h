//
//  OCAppDelegate.h
//  OpenChat
//
//  Created by Ashish Nigam on 17/09/14.
//  Copyright (c) 2014 OpenChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
