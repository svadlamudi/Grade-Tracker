//
//  GTAppDelegate.h
//  Grade Tracker
//
//  Created by SaiMav on 7/21/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistanceStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) UIManagedDocument *managedDocument;
@property (nonatomic) BOOL documentReady;

@end
