//
//  GTAddAssignmentTypeViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/25/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAddAssignmentTypeViewController.h"

@interface GTAddAssignmentTypeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *categoryNameField;
@property (weak, nonatomic) IBOutlet UITextField *categoryWeightField;

@end

@implementation GTAddAssignmentTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Assignment Category";
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.categoryNameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addAssignmentTypeNameField"];
    self.categoryWeightField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"addAssignmentTypeWeightField"];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setValue:self.categoryNameField.text forKey:@"addAssignmentTypeNameField"];
    [[NSUserDefaults standardUserDefaults] setValue:self.categoryWeightField.text forKey:@"addAssignmentTypeWeightField"];
}

- (IBAction) addNewAssignmentCategory:(id)sender {
    if (![self.categoryNameField.text isEqualToString:@""]) {
        AssignmentType *assignmentType = [self assignmentTypeWithName:self.categoryNameField.text andWithCourse:self.course];
        
        if (!assignmentType) {
            assignmentType = [NSEntityDescription insertNewObjectForEntityForName:@"AssignmentType" inManagedObjectContext:self.managedDocument.managedObjectContext];
        }
        
        assignmentType.name = self.categoryNameField.text;
        assignmentType.weight = [NSNumber numberWithDouble:[self.categoryWeightField.text doubleValue]/100];
        assignmentType.course = self.course;
        assignmentType.averageGrade = [NSNumber numberWithFloat:0.0];
        
        self.categoryNameField = nil;
        self.categoryWeightField = nil;
        
        
        [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    }
    [self.addCategoryPopoverController dismissPopoverAnimated:YES];
    self.addCategoryPopoverController = nil;
}

- (AssignmentType *) assignmentTypeWithName:(NSString *) name andWithCourse:(Course *)course {
    AssignmentType *assignmentType = nil;
    
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AssignmentType"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND course.formalName = %@", name, course.formalName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSArray *assignmentTypes = [self.managedDocument.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else if (!assignmentTypes.count) {
        assignmentType = [NSEntityDescription insertNewObjectForEntityForName:@"AssignmentType" inManagedObjectContext:self.managedDocument.managedObjectContext];
    } else if (assignmentTypes.count > 1) {
        NSLog(@"No Unique AssignmentType Found");
    } else if (assignmentTypes.count == 1) {
        assignmentType = [assignmentTypes firstObject];
    }
    
    return assignmentType;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
