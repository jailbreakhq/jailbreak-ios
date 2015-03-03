//
//  JBTabBarController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 03/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTabBarController.h"

@interface JBTabBarController ()

@end

@implementation JBTabBarController

- (BOOL)shouldAutorotate
{
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *selectedViewController = (UINavigationController *)self.selectedViewController;
        return [selectedViewController.viewControllers.lastObject shouldAutorotate];
    }
    else
    {
        return self.selectedViewController.shouldAutorotate;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *selectedViewController = (UINavigationController *)self.selectedViewController;
        return [selectedViewController.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
    }
    else
    {
        return [self.selectedViewController preferredInterfaceOrientationForPresentation];
    }
}

@end
