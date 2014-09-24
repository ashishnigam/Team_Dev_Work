//
//  MasterViewController.h
//  OpenChat
//
//  Created by Ashish Nigam on 17/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"


@class DetailViewController;

@interface MasterViewController : BaseViewController <NSFetchedResultsControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editBtn;
@property NSArray *items;

@end

