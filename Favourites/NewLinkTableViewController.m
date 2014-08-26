//
//  NewLinkViewController.m
//  CoreDataFavourites
//
//  Created by Alek Åström on 2012-03-02.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Apps and Wonders. All rights reserved.
//

// Denna vy-kontroller använder en statisk tabellvy för att visa ett formulär där användaren kan skapa en ny länk. Den ser även till att användaren åtminstone fyllt i något i url-fältet. Titeln är dock valfri. 

// Det som behövs göras här är att skapa ett nytt Link-objekt och spara det i databasen när användaren trycker på spara.

#import "NewLinkTableViewController.h"
#import "Link.h"

@implementation NewLinkTableViewController

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // Visa tangentbordet och sätt markören på titelfältet
    [self.titleField becomeFirstResponder];
    
    [super viewWillAppear:animated];
}

#pragma mark - User interaction

- (IBAction)fieldDidChangeText {
    // Kolla så användaren fyllt i nåt i urlfältet, annars kan man inte spara
    self.saveButton.enabled = ![self.urlField.text isEqualToString:@""];
}
- (IBAction)didPressCancel {
    [self.delegate newLinkControllerDidFinish:self];
}
- (IBAction)didPressSave {
    
#warning Oimplementerat!

}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleField) {
        // Användaren tryckte på "nästa", byt markör till nästa textfält
        [self.urlField becomeFirstResponder];
    } else {
        // Användaren tryckte på "klar". Om användaren får spara, gör det
        if (self.saveButton.enabled) {
            [self didPressSave];
        }
    }
    return YES;
}

@end
