//
//  GTEditCourseViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/24/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTEditCourseViewController.h"

@interface GTEditCourseViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UITextField *formalNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *instructorTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;

@end

@implementation GTEditCourseViewController

- (NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    return _dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.startDateTextField.inputView = datePicker;
    self.endDateTextField.inputView = datePicker;
    
    // Create/Add the toolbar above the keyboard with the "Done" button
    UIToolbar *keyboardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 768, 77)];
    keyboardBar.barStyle = UIBarStyleDefault;
    keyboardBar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditingDate:)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditingDate:)], nil];
    [keyboardBar sizeToFit];
    self.startDateTextField.inputAccessoryView = keyboardBar;
    self.endDateTextField.inputAccessoryView = keyboardBar;

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEditingView)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
}

- (BOOL) disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void) finishEditingDate: (UIBarButtonItem *) sender {
    
    if (self.startDateTextField.isEditing) {
        
        NSDate *date = ((UIDatePicker *)self.startDateTextField.inputView).date;
        self.startDateTextField.text = [self.dateFormatter stringFromDate:date];
        [self.startDateTextField resignFirstResponder];
        
    } else if (self.endDateTextField.isEditing) {
        
        NSDate *date = ((UIDatePicker *)self.endDateTextField.inputView).date;
        self.endDateTextField.text = [self.dateFormatter stringFromDate:date];
        [self.endDateTextField resignFirstResponder];
        
    }
    
}

- (void) cancelEditingDate: (UIBarButtonItem *) sender {
    if (self.startDateTextField.isEditing) {
        [self.startDateTextField resignFirstResponder];
    } else if (self.endDateTextField.isEditing) {
        [self.endDateTextField resignFirstResponder];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.formalNameTextField.text = self.course.formalName;
    self.nickNameTextField.text = self.course.nickName;
    self.instructorTextField.text = self.course.instructor;
    self.startDateTextField.text = [self.dateFormatter stringFromDate:self.course.startDate];
    self.endDateTextField.text = [self.dateFormatter stringFromDate:self.course.endDate];
}

- (IBAction)modifyCourse:(UIButton *)sender {
    
    self.course.formalName = self.formalNameTextField.text;
    self.course.nickName = self.nickNameTextField.text;
    self.course.instructor = self.instructorTextField.text;
    self.course.startDate = [self.dateFormatter dateFromString:self.startDateTextField.text];
    self.course.endDate = [self.dateFormatter dateFromString:self.endDateTextField.text];
    
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteCourse:(UIButton *)sender {
    [self.managedDocument.managedObjectContext deleteObject:self.course];
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) closeEditingView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
