//
//  JBTeamsTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 11/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "JBButton.h"
#import <UIKit/UIKit.h>

@interface JBTeamsTableViewCell : UITableViewCell

@property (nonatomic, weak) JBTeam *team;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *rankLabel;
@property (nonatomic, weak) IBOutlet UILabel *collegeLabel;
@property (nonatomic, weak) IBOutlet UILabel *raisedLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceToXLabel;
@property (nonatomic, weak) IBOutlet UILabel *namesLabel;
@property (nonatomic, weak) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkinLabel;
@property (nonatomic, weak) IBOutlet JBButton *donateButton;

@end
