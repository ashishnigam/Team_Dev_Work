//
//  MasterViewController.m
//  NotingMe
//
//  Created by Ashish Nigam on 11/14/14.
//  Copyright (c) 2014 AshishNigam. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "MyNoteTableViewCell.h"

@interface MasterViewController ()
{
    CGRect screenRect;
}

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(BOOL)checkUserCredential{
    NSUserDefaults *NoteUserDefaults = [NSUserDefaults standardUserDefaults];
    if (![NoteUserDefaults valueForKey:@"userName"] && ![NoteUserDefaults valueForKey:@"password"]) {
        [self presentViewController:[[self storyboard] instantiateViewControllerWithIdentifier:@"loginVC"] animated:YES completion:nil];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    screenRect = [[UIScreen mainScreen] bounds];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(performNewNoteEntry:)];//insertNewObject:
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self checkUserCredential];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isNewNote = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)saveContextChnages {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSError *error;
    BOOL hasData = [[self fetchedResultsController] performFetch:&error];
    NSUInteger length = [[[self fetchedResultsController] fetchedObjects] count];
    if (length && hasData && !error) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        if (object && [[object valueForKey:@"noteText"] isEqualToString:@""]) {
            // delete row
            [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        }
        
        [self.tableView reloadData];
        
        if (context != nil) {
            NSError *error = nil;
            if ([context hasChanges] && ![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    
}

-(void)performNewNoteEntry:(id)args
{
    [self insertNewObject:self];
    isNewNote = YES;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(NSString*)getFormattedDate:(NSDate*)date
{
    NSDate *localDate;
    if (date) {
        localDate = date;
    }else{
        localDate = [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm";
    NSString *timeString = [timeFormatter stringFromDate:localDate];
    
    NSString *dateTimeStr = [NSString stringWithFormat:@"%@\n%@",timeString, dateString];
    return dateTimeStr;
    
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:[self getFormattedDate:nil] forKey:@"noteTime"];
    [newManagedObject setValue:@"" forKey:@"noteText"];
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath;
        if (isNewNote) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }else{
            indexPath = [self.tableView indexPathForSelectedRow];
        }
        
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(MyNoteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.cTitleLbl.text = [object valueForKey:@"noteText"];
    [cell.cDetailTitleLbl setNumberOfLines:2];
    cell.cDetailTitleLbl.text = [object valueForKey:@"noteTime"];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(MyNoteTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
