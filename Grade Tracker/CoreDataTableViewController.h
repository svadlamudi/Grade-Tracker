//
//  CoreDataTableViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/22/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void) performFetch;

@end
