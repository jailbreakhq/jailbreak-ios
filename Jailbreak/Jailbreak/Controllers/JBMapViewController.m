//
//  JBMapViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 19/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBMapViewController.h"

@interface JBMapViewController () <MKMapViewDelegate>

@end

@implementation JBMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    [self.mapView addAnnotations:self.annotations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - MKMapViewDelegate



@end
