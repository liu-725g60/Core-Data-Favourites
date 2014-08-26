//
//  DetailViewController.m
//  Favourites
//
//  Created by Alek Åström on 2012-02-12.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

/**
 Denna vykontroller visar upp en länk i en WebView som täcker hela vykontrollerns storlek.
 Observera att vykontrollern förlitar sig på att ha fått en länk att visa med sin link-property.
 */

// Denna klass har inte ändrats nämnvärt sedan labb 4. Den tar fortfarande emot ett Link-objekt utan att behöva bry sig om att det kommer från en databas.

#import "DetailViewController.h"
#import "MasterViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

// Egen setter för link som uppdaterar gränsnittet så fort länken ändras
- (void)setLink:(Link *)newLink {
    // Om länken är ny, sätt den
    if (self.link != newLink) {
        _link = newLink;
        
        // Uppdatera vyn
        [self configureView];
    }

    // Om mastervyn ligger i en popover så stäng den (observera att vi kan skicka meddelanden till nil-objekt)
    [self.masterPopoverController dismissPopoverAnimated:YES];      
}

// Uppdaterar användargränsnitt för att visa en länk
- (void)configureView {
    // Uppdaterar användargränsnittet för att visa en länk
    if (self.link) {
        [self.webView stopLoading];
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.link.url]];
        self.title = [self.link.title isEqualToString:@""] ? self.link.urlString : self.link.title;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Konfigurera vyn för vår data
    [self configureView];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    // När användaren roterar till stående läge på iPad, sätt titel på knapp
    barButtonItem.title = NSLocalizedString(@"Länkar", @"Länkar");
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.masterPopoverController = popoverController;
    
    UINavigationController *navc = (UINavigationController *)viewController;
    [(MasterViewController *)navc.topViewController setIsInPopover:YES];
    
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItems:nil animated:YES];
    [self.masterPopoverController dismissPopoverAnimated:YES];
    self.masterPopoverController = nil;
    
    UINavigationController *navc = (UINavigationController *)viewController;
    [(MasterViewController *)navc.topViewController setIsInPopover:NO];
}

@end
