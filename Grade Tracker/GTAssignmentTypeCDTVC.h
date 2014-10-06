//
//  GTAssignmentTypeCDTVC.h
//  Grade Tracker
//
//  Created by SaiMav on 7/22/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Course+Methods.h"
#import "GTAssignmentViewController.h"

@interface GTAssignmentTypeCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) GTAssignmentViewController *currentAssignmentTable;

@end
