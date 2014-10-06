//
//  GTAssignmentTableViewCell.h
//  Grade Tracker
//
//  Created by SaiMav on 7/26/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAssignmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assignmentName;
@property (weak, nonatomic) IBOutlet UILabel *assignmentGrade;
@property (weak, nonatomic) IBOutlet UILabel *assignmentDueDate;

@end
