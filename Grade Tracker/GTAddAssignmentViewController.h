//
//  GTAddAssignmentViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/29/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssignmentType+Methods.h"

@interface GTAddAssignmentViewController : UIViewController

@property (nonatomic, strong) UIPopoverController *addAssignmentPopover;
@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) AssignmentType *assignmentType;

@end
