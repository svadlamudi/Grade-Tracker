//
//  GTViewController.m
//  Grade Tracker
//
//  Created by SaiMav on 7/21/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import "GTViewController.h"

@interface GTViewController () <UISplitViewControllerDelegate>

@end

@implementation GTViewController

- (void) awakeFromNib {
    
    self.splitViewController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
