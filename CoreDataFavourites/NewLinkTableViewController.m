//
//  NewLinkTableViewController.m
//  CoreDataFavourites
//
//  Created by Cenny Davidsson on 2014-10-02.
//  Copyright (c) 2014 Linköpings University. All rights reserved.
//

#import "NewLinkTableViewController.h"
#import "Link.h"

@interface NewLinkTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation NewLinkTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Visa tangentbordet och sätt markören på titelfältet
    [self.titleField becomeFirstResponder];
}

#pragma mark - User interaction

- (IBAction)fieldDidChangeText {
    // Kolla så användaren fyllt i nåt i urlfältet, annars kan man inte spara
    self.saveButton.enabled = ![self.urlField.text isEqualToString:@""];
}

- (IBAction)didPressSave {
    
    #warning Oimplementerat!
    
}

- (IBAction)didPressCancel {
    [self.delegate newLinkControllerDidFinish:self];
}

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
