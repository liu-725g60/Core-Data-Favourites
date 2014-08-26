//
//  NewLinkViewController.h
//  CoreDataFavourites
//
//  Created by Alek Åström on 2012-03-02.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class NewLinkTableViewController;

@protocol NewLinkTableViewControllerDelegate
- (void)newLinkControllerDidFinish:(NewLinkTableViewController *)controller;
@end

@interface NewLinkTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <NewLinkTableViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
