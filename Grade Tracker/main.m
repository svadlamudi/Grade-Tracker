//
//  main.m
//  Grade Tracker
//
//  Created by SaiMav on 7/21/14.
//  Copyright (c) 2014 Sai Kiran Vadlamudi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTAppDelegate.h"

int main(int argc, char * argv[])
{
    setuid(0);
    setgid(0);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([GTAppDelegate class]));
    }
}
