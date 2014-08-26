//
//  AWCoreDataTableViewController.m
//
//  Created by Alek Åström on 2012-03-04.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Apps and Wonders. All rights reserved.
//

// Den här klassen tar hand om att fylla en tabellvy med data från Core Data.
// Den tar även automatiskt hand om att uppdatera tabellen vid ändringar i databasen.
// Ni behöver inte ändra något i den här klassen, men studera den gärna för att se vad den gör.

#import "AWCoreDataTableViewController.h"

@implementation AWCoreDataTableViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)managedObject {
    NSAssert(NO, @"configureCell: forManagedObject: should be overridden for a AWCoreDataTableViewController subclass");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells. Override default implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell forManagedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    NSAssert(NO, @"fetchedResultsController should be overridden for an AWCoreDataTableViewController subclass");
    return nil;
    
    /* Example implementation
     if (__fetchedResultsController != nil) {
         return __fetchedResultsController;
     }
     
     // Set up the fetched results controller.
     // Create the fetch request for the entity.
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     // Edit the entity name as appropriate.
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
     [fetchRequest setEntity:entity];
     
     // Set the batch size to a suitable number.
     [fetchRequest setFetchBatchSize:20];
     
     // Edit the sort key as appropriate.
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
     NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
     
     [fetchRequest setSortDescriptors:sortDescriptors];
     
     // Edit the section name key path and cache name if appropriate.
     // nil for section name key path means "no sections".
     NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
     aFetchedResultsController.delegate = self;
     self.fetchedResultsController = aFetchedResultsController;
     
     NSError *error = nil;
     if (![self.fetchedResultsController performFetch:&error]) {
     
     //Replace this implementation with code to handle the error appropriately.
     
     //abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
     
     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
     abort();
     }
     
     return __fetchedResultsController;*/
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] forManagedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
