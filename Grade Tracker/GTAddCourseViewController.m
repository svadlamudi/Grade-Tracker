//
//  GTAddCourseViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/24/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAddCourseViewController.h"
#import "Course+Methods.h"

@interface GTAddCourseViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UITextField *formalNameField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UITextField *instructorField;
@property (weak, nonatomic) IBOutlet UITextField *startDateField;
@property (weak, nonatomic) IBOutlet UITextField *endDateField;

@end

@implementation GTAddCourseViewController

#pragma mark - Properties

- (NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    return _dateFormatter;
}

#pragma mark - UIView Delegate Methods

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.formalNameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addNewCourseFormalNameField"];
    self.nickNameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addNewCourseNickNameField"];
    self.instructorField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addNewCourseInstructorField"];
    self.startDateField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addNewCourseStartDateField"];
    self.endDateField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addNewCourseEndDateField"];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Save temp values into userDefaults
    [[NSUserDefaults standardUserDefaults] setValue:self.formalNameField.text forKey:@"addNewCourseFormalNameField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.nickNameField.text forKey:@"addNewCourseNickNameField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.instructorField.text forKey:@"addNewCourseInstructorField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.startDateField.text forKey:@"addNewCourseStartDateField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.endDateField.text forKey:@"addNewCourseEndDateField"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add New Course";
    
    // Add the clear button to textfields
    self.formalNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nickNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.instructorField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.startDateField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.endDateField.clearButtonMode = UITextFieldViewModeWhileEditing;

    // Create/Add the Date picker to the start and end date fields
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.startDateField.inputView = datePicker;
    self.endDateField.inputView = datePicker;
    
    // Create/Add the toolbar above the keyboard with the "Done" button
    UIToolbar *keyboardBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 768, 77)];
    keyboardBar.barStyle = UIBarStyleDefault;
    keyboardBar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditingDate:)], nil];
    [keyboardBar sizeToFit];
    self.startDateField.inputAccessoryView = keyboardBar;
    self.endDateField.inputAccessoryView = keyboardBar;
    
}

#pragma mark - Temp Variables Save/Clear

- (void) clearTextFieldValues {
    self.formalNameField = nil;
    self.nickNameField = nil;
    self.instructorField = nil;
    self.startDateField = nil;
    self.endDateField = nil;
}

#pragma mark - Target-Action Methods

- (void) finishEditingDate: (UIBarButtonItem *) sender {
    
    if (self.startDateField.isEditing) {
        NSDate *date = ((UIDatePicker *)self.startDateField.inputView).date;
        self.startDateField.text = [self.dateFormatter stringFromDate:date];
        [self.startDateField resignFirstResponder];
    } else if (self.endDateField.isEditing) {
        NSDate *date = ((UIDatePicker *)self.endDateField.inputView).date;
        self.endDateField.text = [self.dateFormatter stringFromDate:date];
        [self.endDateField resignFirstResponder];
    }    
}

- (IBAction)createAndAddNewCourse:(UIButton *)sender {
    if (![self.formalNameField.text isEqualToString:@""]) {
        Course *course = [self courseWithFormalName:self.formalNameField.text];
        
        if (!course) {
            course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedDocument.managedObjectContext];
        }
        
        course.formalName = self.formalNameField.text;
        course.nickName = self.nickNameField.text;
        course.instructor = self.instructorField.text;
        course.startDate = [self.dateFormatter dateFromString:self.startDateField.text];
        course.endDate = [self.dateFormatter dateFromString:self.endDateField.text];
        course.averageGrade = [NSNumber numberWithDouble:0.0];
        
        [self.managedDocument updateChangeCount:UIDocumentChangeDone];
        [self clearTextFieldValues];
        
    }
    [self.addCoursePopover dismissPopoverAnimated:YES];
    self.addCoursePopover = nil;
}

- (Course *) courseWithFormalName: (NSString *) formalName {
    Course *course = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"formalName = %@", formalName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"formalName" ascending:YES]];
    NSError *error;
    NSArray *courses = [self.managedDocument.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else if (courses.count > 1) {
        NSLog(@"No unique course with formal name found");
    } else if (courses.count == 1) {
        course = [courses firstObject];
    } else if (!courses.count) {
        course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedDocument.managedObjectContext];
    }
    
    return course;
}

@end
