//
//  GTAddAssignmentTypeViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/25/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+Methods.h"
#import "AssignmentType+Methods.h"

@interface GTAddAssignmentTypeViewController : UIViewController

@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) UIPopoverController *addCategoryPopoverController;

@end
