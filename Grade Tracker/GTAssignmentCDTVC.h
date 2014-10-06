//
//  GTAssignmentCDTVC.h
//  Grade Tracker
//
//  Created by SaiMav on 7/29/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "AssignmentType+Methods.h"
#import "Assignment+Methods.h"
#import "GTAssignmentTableViewCell.h"
#import "Course+Methods.h"

@interface GTAssignmentCDTVC : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) AssignmentType *assignmentType;
@property (nonatomic) BOOL assignmentTableEditing;

- (void) toggleEditingAssignmentTable;

@end
