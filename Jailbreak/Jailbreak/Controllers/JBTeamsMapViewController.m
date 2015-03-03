//
//  JBTeamsMapViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 20/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "JBService.h"
#import "JBAnnotation.h"
#import <SAMRateLimit.h>
#import "JBTeam+Annotation.h"
#import "UIColor+JBAdditions.h"
#import "JBCircularImageView.h"
#import "JBTeamsMapViewController.h"
#import "UIImageView+WebCacheWithProgress.h"

static NSString * const kSAMBlockName = @"Map";

static const NSTimeInterval kIntervalBetweenRefreshing = 60.0 * 10.0; // 10 minutes

@interface JBTeamsMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *teams;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation JBTeamsMapViewController

- (NSMutableArray *)teams
{
    if (!_teams) _teams = [NSMutableArray new];
    return _teams;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    [self update];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SAMRateLimit executeBlock:^{
        [self update];
    } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *result = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (!result)
    {
        result = [[MKPinAnnotationView alloc] initWithAnnotation:self.mapView.annotations.firstObject reuseIdentifier:@"Pin"];
        result.enabled = YES;
        result.canShowCallout = YES;
        JBCircularImageView *imageView = [[JBCircularImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView.backgroundColor = [UIColor colorWithHexString:@"#D3D6DE"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        result.leftCalloutAccessoryView = imageView;
    }
    
    if ([annotation isKindOfClass:[JBAnnotation class]])
    {
        result.pinColor = MKPinAnnotationColorGreen;
        [(UIImageView *)result.leftCalloutAccessoryView setImage:nil];
    }
    else
    {
        result.pinColor = MKPinAnnotationColorRed;
        [(UIImageView *)result.leftCalloutAccessoryView sd_setImageWithURL:[(JBTeam *)annotation avatarURL]];
    }
    
    return result;
}

#pragma mark - Helper Methods

- (void)handleApplicationDidBecomeActiveNotification
{
    [SAMRateLimit executeBlock:^{
        [self update];
    } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
}

- (void)update
{
    // Fetch teams
    [[JBAPIManager manager] getAllTeamsWithParameters:nil
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  [self.teams removeAllObjects];
                                                  for (NSDictionary *dict in responseObject)
                                                  {
                                                      [self.teams addObject:[[JBTeam alloc] initWithJSON:dict]];
                                                  }
                                                  
                                                  [[JBAPIManager manager] getServicesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      JBService *service = [[JBService alloc] initWithJSON:responseObject];
                                                      JBAnnotation *annotation = [JBAnnotation new];
                                                      annotation.customCoordinate = service.finalLocation.coordinate;
                                                      annotation.customTitle = @"Location X";
                                                      [self.teams addObject:annotation];
                                                      [self.mapView showAnnotations:self.teams animated:YES];
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      [self.mapView showAnnotations:self.teams animated:YES];
                                                  }];

                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  [TSMessage displayMessageWithTitle:@"Failed To Get Teams" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                              }];
}

@end
