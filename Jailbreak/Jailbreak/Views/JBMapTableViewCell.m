//
//  JBMapTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights   reserved.
//

#import "JBAnnotation.h"
#import "JBMapTableViewCell.h"
#import "MKMapView+Snapshot.h"

@implementation JBMapTableViewCell

- (void)setTeam:(JBTeam *)team
{
    _team = team;
    
    self.mapBannerView.backgroundColor = self.team.universityColor;
    self.locationLabel.text = @"Apollobuurt Amsterdam, Netherlands";
    self.distanceLabel.text = [[[self lengthFormatter] stringFromMeters:self.team.distanceToX] stringByAppendingString:@" remaining"];
    
    JBAnnotation *annotation = [JBAnnotation new];
    annotation.customCoordinate = self.team.currentLocation.coordinate;
    [[self mapView] addAnnotation:annotation];
    [[self mapView] showAnnotations:[[self mapView] annotations] animated:NO];
    [[self mapView] createSnapshotWithSize:self.contentView.frame.size
                         completionHandler:^(UIImage *snapshot) {
                             self.mapImageView.image = snapshot;
                         }];
}

- (MKMapView *)mapView
{
    static MKMapView *_mapView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapView = [[MKMapView alloc] initWithFrame:self.contentView.frame];
    });
    
    return _mapView;
}

- (NSLengthFormatter *)lengthFormatter
{
    static NSLengthFormatter *_lengthFormater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lengthFormater = [[NSLengthFormatter alloc] init];
        [_lengthFormater.numberFormatter setLocale:[NSLocale currentLocale]];
        _lengthFormater.numberFormatter.maximumFractionDigits = 0;
    });
    
    return _lengthFormater;
}

@end
