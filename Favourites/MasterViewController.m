//
//  MasterViewController.m
//  Favourites
//
//  Created by Alek Åström on 2012-02-12.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

// Denna vykontroller styr en tabell som visar länkar. När en användare trycker på en länk pushas DetailViewController in på iPhone, medan på iPad så uppdateras bara DetailViewController med en ny länk. Observera även att prepareForSegue körs för att skicka länken till den pushade vykontrollern på iPhone.

// Sedan sist har den här vy-kontrollern även uppdaterats med att kunna lägga till länkar. Detta sker genom att presentera en vy-kontroller som heter NewLinkTableViewController. På iPhone presenteras den som en modal vy medan den på iPad kan presenteras på två olika sätt beroende på interfaceorientering. I liggande läge skapas en ny popover med länkformuläret medan formuläret i stående läge pushas in som en modal vy inuti denna vy-kontrollers popover. Starta appen och lek lite med gränsnittet i stående/liggande läge så ser ni hur det går till.

// Nu när vi ska använda en databas för länkarna behöver vi hantera hämtning ur databasen och vad som sker när data i databasen ändras. Detta sker med hjälp av ett NSFetchedResultsController-objekt och klassen AWCoreDataTableViewController som denna vy-kontroller ärver av. AWCoreDataTableViewController sköter redan inladdning och uppdatering av celler, även när data ändras. Det vi däremot behöver göra själva är att skapa ett NSFetchedResultsController-objekt som laddar in just Link-objekt och sorterar dem efter titel. Detta gör vi genom att överlagra metoden - (NSFetchedResultsController *)fetchedResultsController. Se AWCoreDataTableViewController.m för hur en sådan implementation kan se ut.

// Vi behöver även överlagra metoden configureCell:forManagedObject: som används för att configurera celler med våra Core Data-objekt (i detta fall Link-objekt).

#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPAD()) {
        // Hämta detaljvyn från SplitViewControllern
        self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        // Markera första cellen och sätt första länken till detaljvyn
        if (self.fetchedResultsController.fetchedObjects.count > 0) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            self.detailViewController.link = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        
        // När man öppnar/stänger popovern ska tabellen ej avmarkera celler
        self.clearsSelectionOnViewWillAppear = NO;
    }
    
    // Avkommentera följande för att enkelt få en edit-knapp
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (IS_IPAD() && UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self.popoverControlleriPAD dismissPopoverAnimated:NO];
    }
}

#pragma mark - AWCoreDataTableViewController methods
- (NSFetchedResultsController *)fetchedResultsController {
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
#warning Oimplementerat!
    
    // Skapa och konfigurera en NSFetchedResultsController här
    
    return __fetchedResultsController;
}

- (void)configureCell:(UITableViewCell *)cell forManagedObject:(NSManagedObject *)managedObject {
#warning Oimplementerat!

}

#pragma mark - User interaction
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"linkPush"]) {
        // Skicka länken till detaljvyn
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.link = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        
    } else if ([[segue.identifier substringToIndex:8] isEqualToString:@"new link"]) {
        // Täcker in new link, new link modal, new link popover
        // Sätt oss själva som delegat och skicka managedObjectContext
        UINavigationController *navc = segue.destinationViewController;
        NewLinkTableViewController *newLinkViewController = (NewLinkTableViewController *)navc.topViewController;
        newLinkViewController.delegate = self;
        newLinkViewController.managedObjectContext = self.managedObjectContext;
        
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            // Spara undan popovercontrollern på iPad
            self.popoverControlleriPAD = ((UIStoryboardPopoverSegue *)segue).popoverController;
        } else if (self.isInPopover) {
            // Sker på iPad när länklistan ligger i en popover
            newLinkViewController.modalInPopover = YES;
            newLinkViewController.preferredContentSize = self.view.frame.size;
        }
    }
}
- (IBAction)didPressAdd {
    if (!IS_IPAD()) {
        [self performSegueWithIdentifier:@"new link" sender:self];
    } else {        
        if (self.isInPopover) {
            [self performSegueWithIdentifier:@"new link modal" sender:self];
        } else if ([self.popoverControlleriPAD isPopoverVisible]) {
            [self.popoverControlleriPAD dismissPopoverAnimated:YES];
        } else {
            [self performSegueWithIdentifier:@"new link popover" sender:self];
        }
    }
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!IS_IPAD()) {
        // Om iPhone, pusha in detaljkontrollern
        [self performSegueWithIdentifier:@"linkPush" sender:self];
    } else {
        // Om iPad, sätt data i detaljkontrollern
        self.detailViewController.link = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

#pragma mark - NewLinkTableViewController delegate methods
- (void)newLinkControllerDidFinish:(NewLinkTableViewController *)controller {
    [self.popoverControlleriPAD dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
