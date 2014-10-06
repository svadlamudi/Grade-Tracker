//
//  Course.h
//  Grade Tracker
//
//  Created by SaiMav on 9/14/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssignmentType;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSNumber * averageGrade;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * formalName;
@property (nonatomic, retain) NSString * instructor;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *assignmentCategories;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addAssignmentCategoriesObject:(AssignmentType *)value;
- (void)removeAssignmentCategoriesObject:(AssignmentType *)value;
- (void)addAssignmentCategories:(NSSet *)values;
- (void)removeAssignmentCategories:(NSSet *)values;

@end
