//
//  MasterViewController.h
//  Favourites
//
//  Created by Alek Åström on 2012-02-12.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "NewLinkTableViewController.h"
#import "AWCoreDataTableViewController.h"

@class DetailViewController;

@interface MasterViewController : AWCoreDataTableViewController <NewLinkTableViewControllerDelegate>

// iPad-specifikt:
@property (strong, nonatomic) DetailViewController *detailViewController; // Används på iPad med SplitViewControllern
@property (weak, nonatomic) UIPopoverController *popoverControlleriPAD; // Används på iPad
@property (assign, nonatomic) BOOL isInPopover;
// Stark referens eftersom master-controllern kommer att ta bort den i stående läge

@end