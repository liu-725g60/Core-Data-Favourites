//
//  AppDelegate.m
//  Favourites
//
//  Created by Alek Åström on 2012-02-12.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

#import "AppDelegate.h"
#import "Link.h"
#import "MasterViewController.h"

// Denna appdelegat förbereder split-vyn på iPad och nu tar den även hand om Core Data. Appdelegaten läser in modellfilen som beskriver vilka objekt som finns och vad de har för properties. Den anger även vilken typ av lagring Core Data ska använda sig av, i detta fall en sqlite-databas från en fil som heter favourites.sqlite

@interface AppDelegate ()
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Hämta användarinställningar
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Registrera standardinställning (måste göras vid varje start)
    [userDefaults registerDefaults:@{@"defaultLinksAdded": @NO}];
    
    // Kolla om standardlänkarna blivit inlagda för den här användaren
    if (![[userDefaults objectForKey:@"defaultLinksAdded"] boolValue]) {
        [self addDefaultLinks];
        // Sätt inställningarna så att länkarna inte läggs till igen nästa gång
        [userDefaults setObject:@YES forKey:@"defaultLinksAdded"];
        // Spara inställningarna till permanent minne
        [userDefaults synchronize];
    }
        
    // Sätt upp split view-delegaten
    if (IS_IPAD()) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    // Hämta MasterViewController så vi kan sätta dess initiala data
    MasterViewController *mvc;
    if (IS_IPAD()) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = (splitViewController.viewControllers)[0];
        mvc = (MasterViewController *)navigationController.topViewController;
    } else {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        mvc = (MasterViewController *)navigationController.topViewController;
    }
    
    // Ge managed object context till MasterViewController
    mvc.managedObjectContext = self.managedObjectContext;
    
    return YES;
}

- (void)addDefaultLinks {
    
    Link *firstLink = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:self.managedObjectContext];
    firstLink.urlString = @"http://tinyurl.com/7qnrexr";
    firstLink.title = @"RickRoll'd";
    
    Link *secondLink = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:self.managedObjectContext];
    secondLink.urlString = @"http://www.ida.liu.se/~725G60/index.sv.shtml";
    secondLink.title = @"Kurshemsida";
    
    Link *thirdLink = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:self.managedObjectContext];
    thirdLink.urlString = @"http://www.ida.liu.se/~725G60/forum/";
    thirdLink.title = @"Kursforum";
    
    Link *fourthLink = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:self.managedObjectContext];
    fourthLink.urlString = @"http://www.example.com";
    
    // Spara till databas
    [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil){
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Favourites" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"favourites.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Om vi får problem, ta bort all data.
        // OBS!!! ANVÄND EJ I EN RIKTIG APPLIKATION!!!!!!!
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
