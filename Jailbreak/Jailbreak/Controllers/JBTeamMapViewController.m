//
//  JBTeamMapViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 03/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <NSDate+DateTools.h>
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *result = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (!result)
    {
        result = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@"Pin"];
        result.pinColor = MKPinAnnotationColorRed;
        result.enabled = YES;
        result.canShowCallout = YES;
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0];
        timeLabel.backgroundColor = self.team.universityColor;
        timeLabel.layer.cornerRadius = 20.0;
        timeLabel.layer.masksToBounds = YES;
        timeLabel.textColor = [UIColor whiteColor];
        result.leftCalloutAccessoryView = timeLabel;
    }
    
    [(UILabel *)result.leftCalloutAccessoryView setText:[[(JBCheckin *)annotation createdTime] shortTimeAgoSinceNow]];
    
    return result;
}

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
