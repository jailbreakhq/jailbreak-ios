//
//  JBTeamMapViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 03/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "JBTeamMapViewController.h"

@interface JBTeamMapViewController () <MKMapViewDelegate>

@property (nonatomic, assign) BOOL firstTime;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation JBTeamMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.firstTime = YES;
    
    CLLocationCoordinate2D coordinates[self.team.checkins.count];
    for (int i = 0; i < self.team.checkins.count; i++)
    {
        JBCheckin *checkin = (JBCheckin *)self.team.checkins[i];
        coordinates[i] = checkin.location.coordinate;
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:self.team.checkins.count];
    [self.mapView addOverlay:polyline level:MKOverlayLevelAboveRoads];
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (self.firstTime)
    {
        [self.mapView showAnnotations:self.team.checkins animated:YES];
        self.firstTime = NO;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    polylineRender.strokeColor = self.team.universityColor;
    polylineRender.lineWidth = 4.0;
    
    return polylineRender;
}


@end
