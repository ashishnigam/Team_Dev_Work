//
//  MasterViewController.h
//  LoveNetwork
//
//  Created by Ashish Nigam on 10/23/13.
//  Copyright (c) 2013 OneZeroOne. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WorldLoveNetwork_girl.h"
//#import "WorldLoveNetwork_boy.h"

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "WorldLoveNetworkHeaderView.h"

@interface WorldLoveNetwork : UICollectionViewController <NSFetchedResultsControllerDelegate>
{
    NSArray *ladiesCollection;
    NSArray *gentsCollection;
    NSArray *humanCollection;
    
}

@property (strong, nonatomic) DetailViewController *detailViewController;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(NSArray*)getMaleCollection:(id)params;
-(NSArray*)getFemaleCollection:(id)params;

-(BOOL)moveToNextScreen:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath fromCollection:(NSArray*)genderCollection;

@end
