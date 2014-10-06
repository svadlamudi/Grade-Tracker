//
//  GTCourseCDTVC.m
//  Grade Tracker
//
//  Created by SaiMav on 7/22/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTCourseCDTVC.h"
#import "Course+Methods.h"
#import "GTAssignmentTypeCDTVC.h"
#import "GTAddCourseViewController.h"
#import "GTEditCourseViewController.h"
#import "UINavigationController+KeyboardDismiss.h"
#import "ManagedDocumentReady.h"

@interface GTCourseCDTVC ()

@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleCourseTableEditingMode;
@property (weak, nonatomic) IBOutlet UINavigationItem *topToolBar;
@property (strong, nonatomic) NSMutableArray *selectedIndices;
@property (nonatomic) BOOL courseTableEditing;

@end

@implementation GTCourseCDTVC

#pragma mark - Properties

- (NSMutableArray *) selectedIndices {
    if (!_selectedIndices) {
        _selectedIndices = [[NSMutableArray alloc] init];
    }
    
    return _selectedIndices;
}

#pragma mark - View Lifecycle
- (void) awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpCourseList:) name:UIManagedDocumentReadyAndOpen object:nil];
}

- (void) setUpCourseList: (NSNotification *) notification {
    UIManagedDocument *document = [[notification userInfo] valueForKey:UIManagedDocumentInfo];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"formalName" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Course"
                                 inManagedObjectContext:document.managedObjectContext];
    request.sortDescriptors = @[sort];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                  managedObjectContext:document.managedObjectContext
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:nil];
    self.managedDocument = document;
    [self.refreshControl endRefreshing];
}

- (void) viewDidLoad {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshCourseTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl beginRefreshing];
}

- (void) deleteSelectedCourses {
    
    for (NSIndexPath *indexPath in self.selectedIndices) {
        Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedDocument.managedObjectContext deleteObject:course];
    }
    
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    self.selectedIndices = nil;
}

#pragma mark - Table View Data Source

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Course Cell"
                                                                 forIndexPath:indexPath];
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = course.formalName;
    cell.detailTextLabel.text = course.nickName;
    
    if ([self.selectedIndices containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (self.courseTableEditing) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedDocument.managedObjectContext deleteObject:course];
        [self.managedDocument updateChangeCount:UIDocumentChangeDone];
        if ([self.selectedIndices containsObject:indexPath]) {
            [self.selectedIndices removeObject:indexPath];
        }
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table View Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.courseTableEditing) {
        if ([self.selectedIndices containsObject:indexPath]) {
            [self.selectedIndices removeObject:indexPath];
        } else {
            [self.selectedIndices addObject:indexPath];
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Target-Action Methods

- (IBAction) toggleCourseTableEditingMode:(UIBarButtonItem *)sender {
    if (self.courseTableEditing) {
        self.courseTableEditing = NO;
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        [self deleteSelectedCourses];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleCourseTableEditingMode:)];
        
        [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    } else {
        self.courseTableEditing = YES;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toggleCourseTableEditingMode:)];
        [self.navigationItem setLeftBarButtonItem:doneButton animated:YES];
    }
    [self.tableView reloadData];
}

- (void) refreshCourseTable {
    [self performFetch];
    [self.refreshControl endRefreshing];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqualToString:@"Show AssignmentTypes in Course"]) {
        GTAssignmentTypeCDTVC *gtatvc = (GTAssignmentTypeCDTVC *)[segue destinationViewController];
        Course *course = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        gtatvc.course = course;
        gtatvc.managedDocument = self.managedDocument;
        gtatvc.currentAssignmentTable = (GTAssignmentViewController *)[[[self.splitViewController viewControllers] objectAtIndex:1] topViewController];
    } else if ([segue.identifier isEqualToString:@"Add New Course"]) {
        UIPopoverController *pc = [(UIStoryboardPopoverSegue*)segue popoverController];
        UINavigationController *nc = [segue destinationViewController];
        GTAddCourseViewController *gtacvc = (GTAddCourseViewController *)[[nc viewControllers] firstObject];
        if (pc) {
            gtacvc.addCoursePopover = pc;
        }
        gtacvc.managedDocument = self.managedDocument;
    } else if ([segue.identifier isEqualToString:@"Edit Existing Course"]) {
        UITableViewCell *cell = (UITableViewCell *)(sender);
        Course *course = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
        GTEditCourseViewController *gtecvc = (GTEditCourseViewController *)[[(UINavigationController *) [segue destinationViewController] viewControllers] firstObject];
        gtecvc.title = [NSString stringWithFormat:@"Editing %@", course.formalName];
        gtecvc.managedDocument = self.managedDocument;
        gtecvc.course = course;
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Show AssignmentTypes in Course"]) {
        if (self.courseTableEditing) {
            return NO;
        }
    }
    
    return YES;
}


@end
