//
//  MasterViewController.h
//  LoveNetwork
//
//  Created by Ashish Nigam on 10/23/13.
//  Copyright (c) 2013 OneZeroOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldLoveNetwork.h"

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "WorldLoveNetworkHeaderView_boy.h"

@interface WorldLoveNetwork_boy : WorldLoveNetwork <NSFetchedResultsControllerDelegate>
{
    NSArray *maleCollection;
    
    //UIViewController *vc;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
