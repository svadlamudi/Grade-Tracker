//
//  GTAssignmentViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/26/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTAssignmentViewController.h"
#import "GTAssignmentTableViewCell.h"
#import "GTAddAssignmentViewController.h"
#import "GTEditAssignmentViewController.h"
#import "Assignment+Methods.h"
#import "Course+Methods.h"
#import "UINavigationController+KeyboardDismiss.h"
#import "GTAverageAssignmentTypeViewController.h"

@interface GTAssignmentViewController () <UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *assignmentTableView;


@end

@implementation GTAssignmentViewController

- (void) closeView {
    self.title = nil;
    [self disableButtons];
    [self.assignmentTableView setHidden:YES];
    [self.emptyLabel setHidden:NO];
}

- (void) openView {
    self.title = self.assignmentType.name;
    [self enableButtons];
    [self.emptyLabel setHidden:YES];
}

#pragma mark - Properties

- (GTAssignmentCDTVC *) tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[GTAssignmentCDTVC alloc] init];
    }
    return _tableViewController;
}

- (void) setAssignmentType:(AssignmentType *)assignmentType {
    _assignmentType = assignmentType;
    self.tableViewController.assignmentType = assignmentType;
}

- (void) setManagedDocument:(UIManagedDocument *)managedDocument {
    _managedDocument = managedDocument;
    [self.tableViewController setTableView:self.assignmentTableView];
    [self.tableViewController.refreshControl beginRefreshing];
    self.tableViewController.managedDocument = _managedDocument;
    [self openView];
}

- (void) enableButtons {
    UIBarButtonItem *avgButton = self.navigationItem.rightBarButtonItem;
    avgButton.enabled = YES;
    [self.navigationItem setRightBarButtonItem:avgButton animated:YES];
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    for (UIBarButtonItem *button in self.toolbarItems) {
        button.enabled = YES;
        [toolBarItems addObject:button];
    }
    self.toolbarItems = toolBarItems;
}

- (void) disableButtons {
    UIBarButtonItem *avgButton = self.navigationItem.rightBarButtonItem;
    avgButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:avgButton animated:YES];
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    for (UIBarButtonItem *button in self.toolbarItems) {
        button.enabled = NO;
        [toolBarItems addObject:button];
    }
    self.toolbarItems = toolBarItems;

}

#pragma mark - View Lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.splitViewController.delegate = self;
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableViewController setTableView:self.assignmentTableView];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshAssignments) forControlEvents:UIControlEventValueChanged];
    [self.tableViewController setRefreshControl:refreshControl];

}

#pragma mark - Target-Action Methods

- (void) refreshAssignments {
    [self.tableViewController performFetch];
    [self.tableViewController.refreshControl endRefreshing];
}

- (IBAction)toggleEditAssignments:(UIBarButtonItem *)sender {
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.toolbarItems];
    if (self.tableViewController.assignmentTableEditing) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditAssignments:)];
        [editButton setTintColor: [UIColor blueColor]];
        [newItems replaceObjectAtIndex:0 withObject:editButton];
    } else {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toggleEditAssignments:)];
        [doneButton setTintColor:[UIColor blueColor]];
        [newItems replaceObjectAtIndex:0 withObject:doneButton];
    }
    [self setToolbarItems:newItems animated:YES];
    [self.tableViewController toggleEditingAssignmentTable];
    [self.assignmentType calculateAverage];
    [self.assignmentType.course calculateAverage];
    newItems = nil;
}


#pragma mark - UISplitViewController Methods

- (void) splitViewController:(UISplitViewController *)svc
      willHideViewController:(UIViewController *)aViewController
           withBarButtonItem:(UIBarButtonItem *)barButtonItem
        forPopoverController:(UIPopoverController *)pc {
    if (aViewController.title.length) {
        barButtonItem.title = aViewController.title;
    } else {
        barButtonItem.title = @"Show";
    }
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add New Assignment"]) {
        GTAddAssignmentViewController *gtaavc = (GTAddAssignmentViewController *)[[segue destinationViewController] topViewController];
        gtaavc.assignmentType = self.assignmentType;
        gtaavc.managedDocument = self.managedDocument;
        gtaavc.addAssignmentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    } else if ([segue.identifier isEqualToString:@"Edit Existing Assignment"]) {
        GTEditAssignmentViewController *gteavc = (GTEditAssignmentViewController *)[(UINavigationController *)[segue destinationViewController] topViewController];
        gteavc.managedDocument = self.managedDocument;
        gteavc.assignment = [self.tableViewController.fetchedResultsController objectAtIndexPath:[self.tableViewController.tableView indexPathForCell:((UITableViewCell *)sender)]];
    } else if ([segue.identifier isEqualToString:@"Show Averages Table"]) {
        GTAverageAssignmentTypeViewController *gtaatvc = (GTAverageAssignmentTypeViewController *)[[segue destinationViewController] topViewController];
        gtaatvc.assignmentType = self.assignmentType;
        gtaatvc.managedDocument = self.managedDocument;
    }
}

@end
