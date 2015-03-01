//
//  JBFeedCheckinTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBAnnotation.h"
#import <NSDate+DateTools.h>
#import "MKMapView+Snapshot.h"
#import "JBFeedCheckinTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@interface JBFeedCheckinTableViewCell ()

@property (nonatomic, strong) NSLayoutConstraint *pinViewLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *pinViewTopConstraint;
@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation JBFeedCheckinTableViewCell

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    
//    self.mapView = [MKMapView new];
//    
//}

- (void)configureCellWithPost:(JBPost *)post
{
    self.post = post;
    
    self.avatarImageView.progressColor = post.checkin.limitedTeam.universityColor;
    [self.avatarImageView sd_setImageWithProgressAndURL:post.checkin.limitedTeam.avatarURL];
    self.titleLabel.text = post.checkin.limitedTeam.membersNames;
    self.bodyLabel.text = post.checkin.status;
    self.timeLabel.text = [post.checkin.createdTime shortTimeAgoSinceNow];
    self.locationLabel.text = [NSString stringWithFormat:@"- %@", post.checkin.locationString];
    
    JBAnnotation *annotation = [JBAnnotation new];
    annotation.customCoordinate = post.checkin.location.coordinate;
    
    [[self mapView] setFrame:self.mapImageView.frame];
    
    // Center map around current location with a radius of x meters around it
    [[self mapView] setRegion:MKCoordinateRegionMakeWithDistance(post.checkin.location.coordinate, 500000.0, 500000.0) animated:NO];
    [[self mapView] createSnapshotWithSize:[self mapView].frame.size
                         completionHandler:^(UIImage *snapshot) {
                             self.mapImageView.image = snapshot;
                             
                             CGSize pinViewSize = CGSizeMake(25.0, 25.0);
                             
                             if (!self.pinView)
                             {
                                 CGPoint pinPoint = [[self mapView] convertCoordinate:annotation.coordinate toPointToView:[self mapView]];
                                 
                                 self.pinView = [UIView new];
                                 self.pinView.backgroundColor = [post.checkin.limitedTeam.universityColor colorWithAlphaComponent:0.4];
                                 self.pinView.layer.borderColor = post.checkin.limitedTeam.universityColor.CGColor;
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
        _mapView = [[MKMapView alloc] initWithFrame:self.mapImageView.frame];
    });
    
    return _mapView;
}

@end
