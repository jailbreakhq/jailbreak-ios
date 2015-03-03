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
#import "TTTOrdinalNumberFormatter.h"
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
    MKPinAnnotationView *result;
    
    if ([annotation isKindOfClass:[JBAnnotation class]])
    {
        result = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"LocationXPin"];

        if (!result)
        {
            result = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@"LocationXPin"];
            result.enabled = YES;
            result.canShowCallout = YES;
            result.pinColor = MKPinAnnotationColorGreen;
        }
    }
    else
    {
        result = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"TeamPin"];
        
        if (!result)
        {
            result = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@"TeamPin"];
            result.enabled = YES;
            result.canShowCallout = YES;
            result.pinColor = MKPinAnnotationColorRed;
            
            JBCircularImageView *avatarImageView = [[JBCircularImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            avatarImageView.backgroundColor = [UIColor colorWithHexString:@"#D3D6DE"];
            avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
            result.leftCalloutAccessoryView = avatarImageView;
            
            UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            positionLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0];
            positionLabel.textAlignment = NSTextAlignmentCenter;
            positionLabel.textColor = [UIColor whiteColor];
            positionLabel.layer.cornerRadius = 20.0;
            positionLabel.layer.masksToBounds = YES;
            result.rightCalloutAccessoryView = positionLabel;
        }
        
        [(UILabel *)result.rightCalloutAccessoryView setText:[[self ordinalFormatter] stringFromNumber:@([(JBTeam *)annotation position])]];
        [(UILabel *)result.rightCalloutAccessoryView setBackgroundColor:[(JBTeam *)annotation universityColor]];
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

- (TTTOrdinalNumberFormatter *)ordinalFormatter
{
    static TTTOrdinalNumberFormatter *_ordinalFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ordinalFormatter = [TTTOrdinalNumberFormatter new];
        [_ordinalFormatter setLocale:[NSLocale currentLocale]];
        [_ordinalFormatter setGrammaticalGender:TTTOrdinalNumberFormatterMaleGender];
    });
    
    return _ordinalFormatter;
}

@end
