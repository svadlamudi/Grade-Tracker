//
//  Assignment.h
//  Grade Tracker
//
//  Created by SaiMav on 9/14/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssignmentType;

@interface Assignment : NSManagedObject

@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) AssignmentType *category;

@end
