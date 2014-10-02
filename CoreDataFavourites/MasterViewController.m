//
//  MasterViewController.m
//  CoreDataFavourites
//
//  Created by Cenny Davidsson on 2014-10-02.
//  Copyright (c) 2014 Linköpings University. All rights reserved.
//

/*

 Denna vykontroller styr en tabell som visar länkar. När en användare trycker på en länk pushas DetailViewController 
 in på iPhone, medan på iPad så uppdateras bara DetailViewController med en ny länk. Observera även att prepareForSegue 
 körs för att skicka länken till den pushade vykontrollern på iPhone.

 Sedan sist har den här vy-kontrollern även uppdaterats med att kunna lägga till länkar. Detta sker genom att 
 presentera en vy-kontroller som heter NewLinkTableViewController. På iPhone och iPad presenteras den som en modal vy.
 Starta appen och lek lite med gränsnittet i stående/liggande läge så ser ni hur det går till.

 Nu när vi ska använda en databas för länkarna behöver vi hantera hämtning ur databasen och vad som sker när 
 data i databasen ändras. Detta sker med hjälp av ett NSFetchedResultsController-objekt och klassen 
 MDMFetchedResultsTableDataSource som denna vy-kontroller implemterar via ett delegat. 
 MDMFetchedResultsTableDataSource sköter redan inladdning och uppdatering av celler, även när data ändras. 
 Det vi däremot behöver göra själva är att skapa ett NSFetchedResultsController-objekt som laddar in 
 just Link-objekt och sorterar dem efter titel. Detta gör vi genom att överlagra metoden - (NSFetchedResultsController *)fetchedResultsController. 
 Se längst ner i denna filen för hur en sådan implementation kan se ut.
 
 Vi behöver även överlagra metoden configureCell:forManagedObject: som används för att configurera celler 
 med våra Core Data-objekt (i detta fall Link-objekt).
 
*/
 



#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NewLinkTableViewController.h"
#import "MDMFetchedResultsTableDataSource.h"
#import "Link.h"

@interface MasterViewController () <MDMFetchedResultsTableDataSourceDelegate, NewLinkTableViewControllerDelegate>
@property (nonatomic, strong) MDMFetchedResultsTableDataSource *tableDataSource;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // Hämta detaljvyn
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Om det finns en splitvy i dessa lägen så laddar vi detailView med översta länken.
    if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryHidden ||
        self.splitViewController.displayMode == UISplitViewControllerDisplayModeAllVisible) {
        
        if (self.fetchedResultsController.fetchedObjects.count > 0) {
            self.detailViewController.link = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
    
    [self setupTableDataSource];
}

// Här sätter vi upp MDMFetchedResultsTableDataSource som tar han om logiken för
// NSFetchedResultsControllerDelegate åt oss.
- (void)setupTableDataSource {
    
    self.tableDataSource = [[MDMFetchedResultsTableDataSource alloc] initWithTableView:self.tableView
                                                              fetchedResultsController:[self fetchedResultsController]];
    self.tableDataSource.delegate = self;
    self.tableDataSource.reuseIdentifier = @"Cell";
    self.tableView.dataSource = self.tableDataSource;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showLink"]) {
        
        // Skicka länken till detaljvyn
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.link = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    if ([segue.identifier isEqualToString:@"newLink"]) {
        
        // Sätt oss själva som delegat och skicka managedObjectContext
        UINavigationController *navc = segue.destinationViewController;
        NewLinkTableViewController *newLinkViewController = (NewLinkTableViewController *)navc.topViewController;
        newLinkViewController.delegate = self;
        newLinkViewController.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - MDMFetchedResultsTableDataSourceDelegate

// Här vill du konfiguerar dina celler, denna metod måste implemteras för att
// följa MDMFetchedResultsTableDataSourceDelegate protokoll
- (void)dataSource:(MDMFetchedResultsTableDataSource *)dataSource configureCell:(id)cell withObject:(id)object {
    #warning Oimplementerat!
}

- (void)dataSource:(MDMFetchedResultsTableDataSource *)dataSource
      deleteObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath {
    
    [self.managedObjectContext deleteObject:object];
    [self.managedObjectContext save:nil];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    #warning Oimplementerat!
    // Längst ner i denna filen finner du ett exempel på hur denna metoden
    // skulle kunna implementeras
    
    
    return _fetchedResultsController;
}    

#pragma mark - NewLinkTableViewController delegate methods

- (void)newLinkControllerDidFinish:(NewLinkTableViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
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
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}
*/

@end
