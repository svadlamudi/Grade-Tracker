//
//  AssignmentType+Methods.m
//  Grade Tracker
//
//  Created by SaiMav on 7/26/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "AssignmentType+Methods.h"
#import "Course+Methods.h"

@implementation AssignmentType (Methods)

- (void) calculateAverage {
    double average = 0.0;
    double totalEarnedPoints = 0.0;
    double totalPoints = 0.0;
    for (Assignment *assignment in self.assignments) {
        average += [assignment.grade doubleValue];
        totalEarnedPoints += [assignment.score doubleValue];
        totalPoints += [assignment.total doubleValue];
    }
    if (self.assignments.count > 0) {
        average = average/self.assignments.count;
    } else {
        average = 0.0;
    }
    self.averageGrade = [NSNumber numberWithDouble:average];
    self.totalEarnedPoints = [NSNumber numberWithDouble:totalEarnedPoints];
    self.totalPoints = [NSNumber numberWithDouble:totalPoints];
}

@end
