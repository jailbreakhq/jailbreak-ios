//
//  JBBaseViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBBaseViewController.h"

@interface JBBaseViewController ()

@end

@implementation JBBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackgroundNotification)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackgroundNotification)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)handleApplicationDidEnterBackgroundNotification {}
- (void)handleApplicationDidBecomeActiveNotification {}

@end
