//
//  NewLinkTableViewController.h
//  CoreDataFavourites
//
//  Created by Cenny Davidsson on 2014-10-02.
//  Copyright (c) 2014 Linköpings University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewLinkTableViewController;

@protocol NewLinkTableViewControllerDelegate
- (void)newLinkControllerDidFinish:(NewLinkTableViewController *)controller;
@end

@interface NewLinkTableViewController : UITableViewController

@property (weak, nonatomic) id <NewLinkTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
