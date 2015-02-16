//
//  JBMapTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface JBMapTableViewCell : UITableViewCell

@property (nonatomic, weak) JBTeam *team;

@property (nonatomic, weak) IBOutlet UIImageView *mapImageView;
@property (nonatomic, weak) IBOutlet UIView *mapBannerView;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@end
