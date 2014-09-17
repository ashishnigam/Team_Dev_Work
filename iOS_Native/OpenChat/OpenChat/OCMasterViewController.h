//
//  OCMasterViewController.h
//  OpenChat
//
//  Created by Ashish Nigam on 17/09/14.
//  Copyright (c) 2014 OpenChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCDetailViewController;

#import <CoreData/CoreData.h>

@interface OCMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) OCDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
