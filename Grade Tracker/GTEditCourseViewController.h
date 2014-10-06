//
//  GTEditCourseViewController.h
//  Grade Tracker
//
//  Created by SaiMav on 7/24/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+Methods.h"

@interface GTEditCourseViewController : UIViewController

@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) Course *course;

@end
