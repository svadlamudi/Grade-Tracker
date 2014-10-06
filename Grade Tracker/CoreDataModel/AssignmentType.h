//
//  AssignmentType.h
//  Grade Tracker
//
//  Created by SaiMav on 9/14/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignment, Course;

@interface AssignmentType : NSManagedObject

@property (nonatomic, retain) NSNumber * averageGrade;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * totalEarnedPoints;
@property (nonatomic, retain) NSNumber * totalPoints;
@property (nonatomic, retain) NSSet *assignments;
@property (nonatomic, retain) Course *course;
@end

@interface AssignmentType (CoreDataGeneratedAccessors)

- (void)addAssignmentsObject:(Assignment *)value;
- (void)removeAssignmentsObject:(Assignment *)value;
- (void)addAssignments:(NSSet *)values;
- (void)removeAssignments:(NSSet *)values;

@end
