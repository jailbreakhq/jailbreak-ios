//
//  JBTeamsMapViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 20/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBAnnotation.h"
#import "JBTeamsMapViewController.h"

@interface JBTeamsMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation JBTeamsMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.annotations = [NSMutableArray new];
    self.mapView.delegate = self;
    
    JBAnnotation *bad;
    bad = [JBAnnotation new];
    bad.customCoordinate = CLLocationCoordinate2DMake(53.349805, -6.26031);
    bad.customTitle = @"Team 23";
    [self.annotations addObject:bad];
    
    bad = [JBAnnotation new];
    bad.customCoordinate = CLLocationCoordinate2DMake(51.507351, -0.127758);
    bad.customTitle = @"Team 53";
    [self.annotations addObject:bad];

    bad = [JBAnnotation new];
    bad.customCoordinate = CLLocationCoordinate2DMake(48.856614, 2.352222);
    bad.customTitle = @"Team 27";
    [self.annotations addObject:bad];
    
    bad = [JBAnnotation new];
    bad.customCoordinate = CLLocationCoordinate2DMake(50.064650, 19.94498);
    bad.customTitle = @"Team 29";
    [self.annotations addObject:bad];
    
    bad = [JBAnnotation new];
    bad.customCoordinate = CLLocationCoordinate2DMake(41.902783, 12.496366);
    bad.customTitle = @"Team 33";
    [self.annotations addObject:bad];
    
    bad = [JBAnnotation new];
    bad.customCoordinate = CLLocationCoordinate2DMake(52.370216, 4.895168);
    bad.customTitle = @"Team 55";
    [self.annotations addObject:bad];
    
    bad = [JBAnnotation new];
    bad.customCoordinate = CLLocationCoordinate2DMake(41.385064, 2.173403);
    bad.customTitle = @"Team 3";
    [self.annotations addObject:bad];
    
    [self.mapView addAnnotations:self.annotations];
    [self.mapView viewForAnnotation:self.annotations[0]];
    [self.mapView viewForAnnotation:self.annotations[1]];
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *result = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (!result)
    {
        result = [[MKPinAnnotationView alloc] initWithAnnotation:self.mapView.annotations.firstObject reuseIdentifier:@"Pin"];
    }
    
    if (annotation == self.mapView.annotations.firstObject)
    {
        result.pinColor = MKPinAnnotationColorRed;
    }
    else if (annotation == self.mapView.annotations.lastObject)
    {
        result.pinColor = MKPinAnnotationColorGreen;
    }
    else
    {
        result.pinColor = MKPinAnnotationColorPurple;
    }
    
    return result;
}

@end
