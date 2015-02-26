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

@interface JBMapTableViewCell ()

@property (nonatomic, strong) UIView *pinView;
@property (nonatomic, strong) NSLayoutConstraint *pinViewLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *pinViewTopConstraint;

@end

@implementation JBMapTableViewCell

- (void)setTeam:(JBTeam *)team
{
    _team = team;
    
    self.mapBannerView.backgroundColor = self.team.universityColor;
    self.locationLabel.text = self.team.lastCheckin.locationString;
    self.distanceLabel.text = [[[self lengthFormatter] stringFromMeters:self.team.distanceToX] stringByAppendingString:@" remaining"];
    
    JBAnnotation *annotation = [JBAnnotation new];
    annotation.customCoordinate = self.team.lastCheckin.location.coordinate;
    
    [[self mapView] setFrame:self.contentView.frame];
    
    // Center map around current location with a radius of x meters around it
    [[self mapView] setRegion:MKCoordinateRegionMakeWithDistance(self.team.lastCheckin.location.coordinate, 500000.0, 500000.0) animated:NO];
    
    // Pan center of map up (doesn't change our current location values or the annotation)
    // this is for visual reasons, so the annotation is not in the center, but rather higher up...
    CGPoint coordinateInPoints = [[self mapView] convertCoordinate:[[self mapView] centerCoordinate] toPointToView:[self mapView]];
    coordinateInPoints.y += 30;
    CLLocationCoordinate2D coordinate = [[self mapView] convertPoint:coordinateInPoints toCoordinateFromView:[self mapView]];
    
    [[self mapView] setCenterCoordinate:coordinate animated:NO];
    [[self mapView] createSnapshotWithSize:[self mapView].frame.size
                         completionHandler:^(UIImage *snapshot) {
                             self.mapImageView.image = snapshot;
                             
                             if (!self.pinView)
                             {
                                 CGSize pinViewSize = CGSizeMake(45.0, 45.0);
                                 CGPoint pinPoint = [[self mapView] convertCoordinate:annotation.coordinate toPointToView:[self mapView]];
                                 
                                 self.pinView = [UIView new];
                                 self.pinView.backgroundColor = [self.team.universityColor colorWithAlphaComponent:0.4];
                                 self.pinView.layer.borderColor = self.team.universityColor.CGColor;
                                 self.pinView.layer.borderWidth = 2.0;
                                 self.pinView.layer.cornerRadius = pinViewSize.width / 2.0;
                                 self.pinView.layer.masksToBounds = YES;
                                 self.pinView.translatesAutoresizingMaskIntoConstraints = NO;
                                 [self.mapImageView addSubview:self.pinView];
                                 
                                 self.pinViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.pinView
                                                                                           attribute:NSLayoutAttributeLeft
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:self.mapImageView
                                                                                           attribute:NSLayoutAttributeLeft
                                                                                          multiplier:1.0
                                                                                            constant:pinPoint.x - (pinViewSize.width / 2.0)];
                                 [self.mapImageView addConstraint:self.pinViewLeftConstraint];
                                 
                                 self.pinViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.pinView
                                                                                          attribute:NSLayoutAttributeTop
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:self.mapImageView
                                                                                          attribute:NSLayoutAttributeTop
                                                                                         multiplier:1.0
                                                                                           constant:pinPoint.y - (pinViewSize.height / 2.0)];
                                 [self.mapImageView addConstraint:self.pinViewTopConstraint];
                                 
                                 [self.mapImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView
                                                                                               attribute:NSLayoutAttributeWidth
                                                                                               relatedBy:NSLayoutRelationEqual
                                                                                                  toItem:nil
                                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                                              multiplier:1.0
                                                                                                constant:pinViewSize.width]];
                                  
                                  [self.mapImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView
                                                                                                attribute:NSLayoutAttributeHeight
                                                                                                relatedBy:NSLayoutRelationEqual
                                                                                                   toItem:nil
                                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                                               multiplier:1.0
                                                                                                 constant:pinViewSize.height]];
                             }
                             else
                             {
                                 CGSize pinViewSize = CGSizeMake(45.0, 45.0);
                                 CGPoint pinPoint = [[self mapView] convertCoordinate:annotation.coordinate toPointToView:[self mapView]];

                                 self.pinViewLeftConstraint.constant = pinPoint.x - (pinViewSize.width / 2.0);
                                 self.pinViewTopConstraint.constant = pinPoint.y - (pinViewSize.height / 2.0);
                             }
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
