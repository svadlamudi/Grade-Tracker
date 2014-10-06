//
//  GTEditAssignmentViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/29/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTEditAssignmentViewController.h"
#import "Course+Methods.h"

@interface GTEditAssignmentViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UITextField *assignmentName;
@property (weak, nonatomic) IBOutlet UITextField *assignmentScore;
@property (weak, nonatomic) IBOutlet UITextField *assignmentTotal;
@property (weak, nonatomic) IBOutlet UITextField *assignmentDueDate;

@end

@implementation GTEditAssignmentViewController

#pragma mark - Properties

- (NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    return _dateFormatter;
}

#pragma mark - View Lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Editing %@", self.assignment.name];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = self.assignment.dueDate;
    self.assignmentDueDate.inputView = datePicker;
    
    UIToolbar *keyboardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 768, 77)];
    keyboardBar.barStyle = UIBarStyleDefault;
    keyboardBar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditingDate:)], nil];
    [keyboardBar sizeToFit];
    self.assignmentDueDate.inputAccessoryView = keyboardBar;

    
    self.assignmentName.text = self.assignment.name;
    self.assignmentScore.text = [NSString stringWithFormat:@"%.1f", [self.assignment.score doubleValue]];
    self.assignmentTotal.text = [NSString stringWithFormat:@"%ld", (long)[self.assignment.total integerValue]];
    self.assignmentDueDate.text = [self.dateFormatter stringFromDate:self.assignment.dueDate];
}

#pragma mark - Target-Action

- (void) finishEditingDate:(UIBarButtonItem *)sender {
    self.assignmentDueDate.text = [self.dateFormatter stringFromDate:((UIDatePicker *)self.assignmentDueDate.inputView).date];
    [self.assignmentDueDate resignFirstResponder];
}

- (IBAction)modifyExistingAssignment:(UIButton *)sender {
    self.assignment.name = self.assignmentName.text;
    self.assignment.score = [NSNumber numberWithDouble:[self.assignmentScore.text doubleValue]];
    self.assignment.total = [NSNumber numberWithDouble:[self.assignmentTotal.text doubleValue]];
    self.assignment.grade = [NSNumber numberWithDouble:[self.assignment.score doubleValue]/[self.assignment.total doubleValue]];
    self.assignment.dueDate = [self.dateFormatter dateFromString:self.assignmentDueDate.text];    \
    
    [self.assignment.category calculateAverage];
    [self.assignment.category.course calculateAverage];
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteExistingAssignment:(UIButton *)sender {
    AssignmentType *category = self.assignment.category;
    [self.managedDocument.managedObjectContext deleteObject:self.assignment];
    self.assignment = nil;
    [category calculateAverage];
    [category.course calculateAverage];
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeEditingView:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
