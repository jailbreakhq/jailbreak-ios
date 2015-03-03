//
//  JBFeedCheckinTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <NSDate+DateTools.h>
#import "MKMapView+Snapshot.h"
#import "JBFeedCheckinTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@interface JBFeedCheckinTableViewCell ()

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation JBFeedCheckinTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 65.0 - 10.0;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, width, width/4.0)];
}

- (void)configureCellWithPost:(JBPost *)post
{
    self.post = post;
    
    self.avatarImageView.progressColor = post.checkin.limitedTeam.universityColor;
    [self.avatarImageView sd_setImageWithProgressAndURL:post.checkin.limitedTeam.avatarURL];
    self.titleLabel.text = post.checkin.limitedTeam.membersNames;
    self.bodyLabel.text = post.checkin.status;
    self.timeLabel.text = [post.checkin.createdTime shortTimeAgoSinceNow];
    self.locationLabel.text = [NSString stringWithFormat:@"- %@", post.checkin.locationString];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 65.0 - 10.0;
    if (self.mapView.frame.size.width != width) self.mapView.frame = CGRectMake(0, 0, width, width/4.0);
    
    // Center map around current location with a radius of x meters around it
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(post.checkin.location.coordinate, 500000.0, 500000.0) animated:NO];
    [self.mapView createSnapshotWithSize:self.mapView.frame.size
                       completionHandler:^(UIImage *snapshot) {
                           self.mapImageView.image = snapshot;
                           
                           CGSize pinViewSize = CGSizeMake(25.0, 25.0);
                           CGPoint pinPoint = [self.mapView convertCoordinate:post.checkin.location.coordinate toPointToView:self.mapView];

                           if (!self.pinView)
                           {
                               self.pinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pinViewSize.width, pinViewSize.height)];
                               self.pinView.backgroundColor = [post.checkin.limitedTeam.universityColor colorWithAlphaComponent:0.4];
                               self.pinView.layer.borderColor = post.checkin.limitedTeam.universityColor.CGColor;
                               self.pinView.layer.borderWidth = 2.0;
                               self.pinView.layer.cornerRadius = pinViewSize.width / 2.0;
                               self.pinView.layer.masksToBounds = YES;
                               [self.mapImageView addSubview:self.pinView];
                               self.pinView.center = pinPoint;
                           }
                       }];
}

@end
