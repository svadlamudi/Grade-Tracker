//
//  GTAddCourseViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/24/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAddCourseViewController : UIViewController

@property (nonatomic, weak) UIManagedDocument *managedDocument;
@property (nonatomic, strong) UIPopoverController *addCoursePopover;

@end
