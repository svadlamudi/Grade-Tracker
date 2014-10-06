//
//  GTAverageAssignmentTypeViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/30/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "AssignmentType+Methods.h"

@interface GTAverageAssignmentTypeViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) AssignmentType *assignmentType;

@end
