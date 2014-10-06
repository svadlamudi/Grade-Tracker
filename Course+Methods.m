//
//  Course+Methods.m
//  Grade Tracker
//
//  Created by SaiMav on 7/26/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "Course+Methods.h"
#import "AssignmentType+Methods.h"

@implementation Course (Methods)

- (void) calculateAverage {
    double average = 0.0;
    double sumWeights = 0.0;
    double totalEarnedPoints = 0.0;
    double totalPoints = 0.0;
    for (AssignmentType *category in self.assignmentCategories) {
        if (category.assignments.count > 0) {
            average += [category.averageGrade doubleValue] * [category.weight doubleValue];
        } else {
            average += (double)1.0 * [category.weight doubleValue];
        }
        totalEarnedPoints += [category.totalEarnedPoints doubleValue];
        totalPoints += [category.totalPoints doubleValue];
        sumWeights += [category.weight doubleValue];
    }
    if (sumWeights > 1.0) {
        self.averageGrade = [NSNumber numberWithDouble:(totalEarnedPoints/totalPoints)];
    } else {
        self.averageGrade = [NSNumber numberWithDouble:average];
    }
}

@end
