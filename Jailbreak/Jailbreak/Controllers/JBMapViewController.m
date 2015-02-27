//
//  JBMapViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 19/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBMapViewController.h"

@interface JBMapViewController () <MKMapViewDelegate>

@property (nonatomic, assign) BOOL firstTime;

@end

@implementation JBMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.firstTime = YES;
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (self.firstTime)
    {
        [self.mapView showAnnotations:self.annotations animated:YES];
        self.firstTime = NO;
    }
}

@end
