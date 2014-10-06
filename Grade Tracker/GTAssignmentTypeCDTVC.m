//
//  GTAssignmentTypeCDTVC.m
//  Grade Tracker
//
//  Created by SaiMav on 7/22/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAssignmentTypeCDTVC.h"
#import "AssignmentType+Methods.h"
#import "GTAddAssignmentTypeViewController.h"
#import "GTEditAssignmentTypeViewController.h"
#import "UINavigationController+KeyboardDismiss.h"

@interface GTAssignmentTypeCDTVC ()

@property (strong, nonatomic) NSMutableArray *selectedIndices;
@property (nonatomic) BOOL assignmentTypeTableEditing;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleEditing;

@end

@implementation GTAssignmentTypeCDTVC

#pragma mark - Properties

- (NSMutableArray *) selectedIndices {
    if (!_selectedIndices) {
        _selectedIndices = [[NSMutableArray alloc] init];
    }
    return _selectedIndices;
}

- (void) setCourse:(Course *)course {
    _course = course;
    self.title = course.formalName;
    [self.refreshControl beginRefreshing];
}

- (void) setManagedDocument:(UIManagedDocument *)managedDocument {
    _managedDocument = managedDocument;
    [self.refreshControl beginRefreshing];
    [self setupFetchedResultsController];
    [self.refreshControl endRefreshing];
}

#pragma mark - View Lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshAssignmentTypeTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    GTAssignmentViewController *detailView = ((GTAssignmentViewController *)([[[self.navigationController.splitViewController viewControllers] objectAtIndex:1] topViewController]));
    detailView.emptyLabel.text = @"Please Choose a Category";
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
    [self.currentAssignmentTable closeView];
    self.currentAssignmentTable.assignmentType = nil;
    GTAssignmentViewController *detailView = ((GTAssignmentViewController *)([[[self.navigationController.splitViewController viewControllers] objectAtIndex:1] topViewController]));
    detailView.emptyLabel.text = @"Please Choose a Course";
}

#pragma mark - Setup FetchedResultsController

- (void) setupFetchedResultsController {
    
    if (self.managedDocument.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AssignmentType"];
        request.predicate = [NSPredicate predicateWithFormat:@"course.formalName = %@", self.course.formalName];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedDocument.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Target-Action Methods

- (void) refreshAssignmentTypeTable {
    [self performFetch];
    [self.refreshControl endRefreshing];
}

- (void) deleteSelectedIndices {
    for (NSIndexPath *indexPath in self.selectedIndices) {
        AssignmentType *assignmentType = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedDocument.managedObjectContext deleteObject:assignmentType];
    }
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
    self.selectedIndices = nil;
}

- (IBAction)toggleEditingAssigmentTypeTable:(UIBarButtonItem *)sender {
    if (self.assignmentTypeTableEditing) {
        self.assignmentTypeTableEditing = NO;
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        [self deleteSelectedIndices];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditingAssigmentTypeTable:)];
        NSArray *items = [NSArray arrayWithObjects:editButton, nil];
        [self setToolbarItems:items animated:YES];
    } else {
        self.assignmentTypeTableEditing = YES;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toggleEditingAssigmentTypeTable:)];
        NSArray *items = [NSArray arrayWithObjects:doneButton, nil];
        [self setToolbarItems:items animated:YES];
    }
    [self.course calculateAverage];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AssignmentType Cell"];
    
    AssignmentType *type = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = type.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", type.weight];
    
    if ([self.selectedIndices containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (self.assignmentTypeTableEditing) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AssignmentType *assignmentType = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedDocument.managedObjectContext deleteObject:assignmentType];
        [self.managedDocument updateChangeCount:UIDocumentChangeDone];
        if ([self.selectedIndices containsObject:indexPath]) {
            [self.selectedIndices removeObject:indexPath];
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.assignmentTypeTableEditing) {
        if ([self.selectedIndices containsObject:indexPath]) {
            [self.selectedIndices removeObject:indexPath];
        } else {
            [self.selectedIndices addObject:indexPath];
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
        AssignmentType *assignmentType = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (![self.currentAssignmentTable.assignmentType.name isEqualToString:assignmentType.name]) {
            self.currentAssignmentTable.assignmentType = assignmentType;
            self.currentAssignmentTable.managedDocument = self.managedDocument;
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add AssignmentType"]) {
        GTAddAssignmentTypeViewController *gtaatvc = (GTAddAssignmentTypeViewController *)[[(UINavigationController *)[segue destinationViewController] childViewControllers] firstObject];
        UIPopoverController *addAsssignmentTypePopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        gtaatvc.managedDocument = self.managedDocument;
        gtaatvc.course = self.course;
        gtaatvc.addCategoryPopoverController = addAsssignmentTypePopover;
    } else if ([segue.identifier isEqualToString:@"Edit AssignmentType"]) {
        GTEditAssignmentTypeViewController *gteatvc = (GTEditAssignmentTypeViewController *)[[(UINavigationController *)[segue destinationViewController] childViewControllers] firstObject];
        gteatvc.managedDocument = self.managedDocument;
        AssignmentType *assignmentType = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        gteatvc.assignmentType = assignmentType;
    }
}


@end
