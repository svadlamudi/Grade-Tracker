//
//  GTAverageAssignmentTypeViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/30/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAverageAssignmentTypeViewController.h"
#import "Course+Methods.h"

@interface GTAverageAssignmentTypeViewController ()

@end

@implementation GTAverageAssignmentTypeViewController

#pragma mark - Properties

- (void) setManagedDocument:(UIManagedDocument *)managedDocument {
    _managedDocument = managedDocument;
    if (managedDocument) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AssignmentType"];
        request.predicate = [NSPredicate predicateWithFormat:@"course.formalName = %@", self.assignmentType.course.formalName];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedDocument.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
}

- (void) setAssignmentType:(AssignmentType *)assignmentType {
    _assignmentType = assignmentType;
    self.title = [NSString stringWithFormat:@"%@ : %3.2f", _assignmentType.course.formalName, [_assignmentType.course.averageGrade floatValue]*100];
}

- (void) viewDidLoad {
    [[[self navigationController] navigationBar] setTranslucent:YES];
}

#pragma mark - UITableView Datasource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Average Cells"];
    AssignmentType *assignmentType = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = assignmentType.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f", [assignmentType.averageGrade doubleValue]*100];
    
    return cell;
}

@end
