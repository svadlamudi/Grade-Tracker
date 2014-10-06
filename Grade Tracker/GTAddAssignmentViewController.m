//
//  GTAddAssignmentViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/29/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAddAssignmentViewController.h"
#import "Assignment+Methods.h"
#import "Course+Methods.h"

@interface GTAddAssignmentViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UITextField *assignmentNameField;
@property (weak, nonatomic) IBOutlet UITextField *assignmentScoreField;
@property (weak, nonatomic) IBOutlet UITextField *assignmentTotalField;
@property (weak, nonatomic) IBOutlet UITextField *assignmentDueDateField;

@end

@implementation GTAddAssignmentViewController

- (NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    
    return _dateFormatter;
}

- (void) viewDidLoad {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.assignmentDueDateField.inputView = datePicker;
    
    UIToolbar *keyboardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 768, 77)];
    keyboardBar.barStyle = UIBarStyleDefault;
    keyboardBar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditingDate:)], nil];
    [keyboardBar sizeToFit];
    self.assignmentDueDateField.inputAccessoryView = keyboardBar;
    
    self.title = @"Add new Assignment";
}

- (void) viewWillAppear:(BOOL)animated {
    self.assignmentNameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addAssignmentNameField"];
    self.assignmentScoreField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addAssignmentScoreField"];
    self.assignmentTotalField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addAssignmentTotalField"];
    self.assignmentDueDateField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addAssignmentDueDateField"];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setValue:self.assignmentNameField.text forKey:@"addAssignmentNameField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.assignmentScoreField.text forKey:@"addAssignmentScoreField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.assignmentTotalField.text forKey:@"addAssignmentTotalField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.assignmentDueDateField.text forKey:@"addAssignmentDueDateField"];
}

- (IBAction)createAddNewAssignment:(UIButton *)sender {
    if (![self.assignmentNameField.text isEqualToString:@""]) {
        Assignment *assignment = [self assignmentWithName:self.assignmentNameField.text];
        
        assignment.name = self.assignmentNameField.text;
        assignment.score = [NSNumber numberWithDouble:[self.assignmentScoreField.text doubleValue]];
        assignment.total = [NSNumber numberWithDouble:[self.assignmentTotalField.text doubleValue]];
        assignment.grade = [NSNumber numberWithDouble:[assignment.score doubleValue]/[assignment.total doubleValue]];
        assignment.dueDate = [self.dateFormatter dateFromString:self.assignmentDueDateField.text];
        
        [self.assignmentType addAssignmentsObject:assignment];
        [self.assignmentType calculateAverage];
        [self.assignmentType.course calculateAverage];
        [self.managedDocument updateChangeCount:UIDocumentChangeDone];
        
    }
    
    self.assignmentNameField.text = nil;
    self.assignmentScoreField.text = nil;
    self.assignmentTotalField.text = nil;
    self.assignmentDueDateField.text = nil;
    
    [self.addAssignmentPopover dismissPopoverAnimated:YES];
    self.addAssignmentPopover = nil;
}

- (void) finishEditingDate:(UIBarButtonItem *)sender {
    self.assignmentDueDateField.text = [self.dateFormatter stringFromDate:((UIDatePicker *)(self.assignmentDueDateField.inputView)).date];
    [self.assignmentDueDateField resignFirstResponder];
}

- (Assignment *) assignmentWithName:(NSString *)name {
    Assignment *assignment = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Assignment"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND category.name = %@ AND category.course.formalName = %@", name, self.assignmentType.name, self.assignmentType.course.formalName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error;
    NSArray *assignments = [self.managedDocument.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else if (assignments.count > 1) {
        
    } else if (!assignments.count) {
        assignment = (Assignment *)[NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:self.managedDocument.managedObjectContext];
    } else if (assignments.count == 1) {
        assignment = [assignments firstObject];
    }
    
    return assignment;
}

@end
