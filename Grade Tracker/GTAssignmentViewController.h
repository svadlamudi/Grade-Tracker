//
//  GTAssignmentViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/26/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAssignmentCDTVC.h"
#import "AssignmentType+Methods.h"

@interface GTAssignmentViewController : UIViewController

@property (nonatomic, strong) GTAssignmentCDTVC *tableViewController;
@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) AssignmentType *assignmentType;

@property (nonatomic, strong) IBOutlet UILabel *emptyLabel;

- (void) closeView;
- (void) openView;

@end
