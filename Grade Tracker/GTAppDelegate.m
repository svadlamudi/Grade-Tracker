//
//  GTAppDelegate.m
//  Grade Tracker
//
//  Created by SaiMav on 7/21/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAppDelegate.h"
#import "ManagedDocumentReady.h"

#define CORE_DATA_AUTO_SAVE_INTERVAL 5*60;

@implementation GTAppDelegate

#pragma mark - Properties

@synthesize window = _window;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistanceStoreCoordinator = _persistanceStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedDocument = _managedDocument;

- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = self.managedDocument.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *) persistanceStoreCoordinator {
    if (!_persistanceStoreCoordinator) {
    }
   
    return _persistanceStoreCoordinator;
}

- (NSManagedObjectModel *) managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = self.managedDocument.managedObjectModel;
    }
    return _managedObjectModel;
}

- (UIManagedDocument *) managedDocument {
    if (!_managedDocument) {
        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption: @YES
                                  };
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                              inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"Grade Database";
        NSURL *fileURL = [documentsDirectory URLByAppendingPathComponent:documentName];
        _managedDocument = [[UIManagedDocument alloc] initWithFileURL:fileURL];
        _managedDocument.persistentStoreOptions = options;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
            [_managedDocument openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    [self documentIsReady];
                }
            }];
        } else {
            [_managedDocument saveToURL:fileURL
                       forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:^(BOOL success){
                          if (success) {
                              [self.managedDocument openWithCompletionHandler:^(BOOL success) {
                                  if (success) {
                                      [self documentIsReady];
                                  }
                              }];
                          }
                      }];
        }
        
    }
    
    return _managedDocument;
}

#pragma mark - Application Opened

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];
    [self documentIsReady];
    self.window.tintColor = [UIColor blueColor];
    return YES;
}

- (void) managedObjectContextDidSave:(NSNotification *) notification {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(managedObjectContextDidSave:) withObject:notification waitUntilDone:YES];
        return;
    }
    
    if (notification.object != self.managedObjectContext) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }}

#pragma mark - Test Methods

- (void) documentIsReady {
    if (self.managedDocument.documentState == UIDocumentStateNormal) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UIManagedDocumentReadyAndOpen
                                                            object:self
                                                          userInfo:@{UIManagedDocumentInfo : self.managedDocument}];
    }
}

#pragma mark - Application Multitask

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.managedDocument saveToURL:self.managedDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            
        }
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark - Application Closed

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
