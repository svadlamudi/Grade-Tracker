//
//  GTAssignmentCDTVC.m
//  Grade Tracker
//
//  Created by SaiMav on 7/29/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAssignmentCDTVC.h"

@interface GTAssignmentCDTVC ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray *selectedIndices;

@end

@implementation GTAssignmentCDTVC

#pragma mark - Properties

- (NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    return _dateFormatter;
}

- (NSMutableArray *) selectedIndices {
    if (!_selectedIndices) {
        _selectedIndices = [[NSMutableArray alloc] init];
    }
    return _selectedIndices;
}

- (void) setManagedDocument:(UIManagedDocument *)managedDocument {
    _managedDocument = managedDocument;
    [self.tableView setHidden:NO];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (_managedDocument) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Assignment"];
        request.predicate = [NSPredicate predicateWithFormat:@"category.name = %@ AND category.course.formalName = %@", self.assignmentType.name, self.assignmentType.course.formalName];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                                managedObjectContext:self.managedDocument.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    }
    [self.refreshControl endRefreshing];
}

- (void) deleteSelectedIndices {
    for (NSIndexPath *indexPath in self.selectedIndices) {
        Assignment *assignment = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedDocument.managedObjectContext deleteObject:assignment];
    }
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    self.selectedIndices = nil;
}

#pragma mark - UITableView Methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTAssignmentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Assignment Cell"];
    
    Assignment *assignment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.assignmentName.text = assignment.name;
    cell.assignmentGrade.text = [NSString stringWithFormat:@"%0.2f", [assignment.grade doubleValue]*100];
    cell.assignmentDueDate.text = [self.dateFormatter stringFromDate:assignment.dueDate];
    
    if ([self.selectedIndices containsObject: indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (self.assignmentTableEditing) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.assignmentTableEditing) {
        if ([self.selectedIndices containsObject:indexPath]) {
            [self.selectedIndices removeObject:indexPath];
        } else {
            [self.selectedIndices addObject:indexPath];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Target-Action Methods

- (void) toggleEditingAssignmentTable {
    if (self.assignmentTableEditing) {
        self.assignmentTableEditing = NO;
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        [self deleteSelectedIndices];
        [self.tableView reloadData];
    } else {
        self.assignmentTableEditing = YES;
        self.selectedIndices = nil;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        [self.tableView reloadData];
    }
}

@end
