//
//  GTEditAssignmentViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/29/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment+Methods.h"
#import "AssignmentType+Methods.h"

@interface GTEditAssignmentViewController : UIViewController

@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) Assignment *assignment;

@end
