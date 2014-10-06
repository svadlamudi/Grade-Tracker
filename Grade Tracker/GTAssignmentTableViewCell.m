//
//  GTAssignmentTableViewCell.m
//  Grade Tracker
//
//  Created by SaiMav on 7/26/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAssignmentTableViewCell.h"

@implementation GTAssignmentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void) setAssignmentName:(UILabel *)assignmentName {
    _assignmentName = assignmentName;
    [self setNeedsDisplay];
}

- (void) setAssignmentGrade:(UILabel *)assignmentGrade {
    _assignmentGrade = assignmentGrade;
    [self setNeedsDisplay];
}

- (void) setAssignmentDueDate:(UILabel *)assignmentDueDate {
    _assignmentDueDate = assignmentDueDate;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
