//
//  GTEditAssignmentTypeViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/25/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTEditAssignmentTypeViewController.h"

@interface GTEditAssignmentTypeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *assignmentTypeNameField;
@property (weak, nonatomic) IBOutlet UITextField *assignmentTypeWeightField;

@end

@implementation GTEditAssignmentTypeViewController

- (void) setAssignmentType:(AssignmentType *)assignmentType {
    _assignmentType = assignmentType;
    self.title = [NSString stringWithFormat:@"Editing %@", self.assignmentType.name];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.assignmentTypeNameField.text = self.assignmentType.name;
    self.assignmentTypeWeightField.text = [NSString stringWithFormat:@"%f", [self.assignmentType.weight doubleValue]*100];
}


- (IBAction)modifyExistingAssignmentType:(UIButton *)sender {
    self.assignmentType.name = self.assignmentTypeNameField.text;
    if ([self.assignmentTypeWeightField.text doubleValue] != [self.assignmentType.weight doubleValue]) {
        self.assignmentType.weight = [NSNumber numberWithDouble:[self.assignmentTypeWeightField.text doubleValue]/100];
    }
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteExistingAssignmentType:(UIButton *)sender {
    [self.managedDocument.managedObjectContext deleteObject:self.assignmentType];
    self.assignmentType = nil;
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeEditScreen:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) disablesAutomaticKeyboardDismissal {
    return NO;
}

@end
