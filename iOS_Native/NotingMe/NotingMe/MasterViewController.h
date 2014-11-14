//
//  MasterViewController.h
//  NotingMe
//
//  Created by Ashish Nigam on 11/14/14.
//  Copyright (c) 2014 AshishNigam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    BOOL isNewNote;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContextChnages;

@end

