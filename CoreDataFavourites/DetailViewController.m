//
//  DetailViewController.m
//  CoreDataFavourites
//
//  Created by Cenny Davidsson on 2014-10-02.
//  Copyright (c) 2014 Linköpings University. All rights reserved.
//

/*
 Denna vykontroller visar upp en länk i en WebView som täcker hela vykontrollerns storlek.
 Observera att vykontrollern förlitar sig på att ha fått en länk att visa med sin link-property.
 */

// Denna klass har inte ändrats nämnvärt sedan labb 4. Den tar fortfarande emot ett Link-objekt utan att behöva bry sig om att det kommer från en databas.

#import "DetailViewController.h"
#import "Link.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


@end
