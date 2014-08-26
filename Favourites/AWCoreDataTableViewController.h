//
//  AWCoreDataTableViewController.h
//
//  Created by Alek Åström on 2012-03-04.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Apps and Wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AWCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *__fetchedResultsController;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Getter must be overridden to provide a lazily loaded fetchedResultsController 
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// This method should be overridden to provide table view cells with data
- (void)configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)managedObject;

@end