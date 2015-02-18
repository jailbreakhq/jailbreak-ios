//
//  JBTeamStatsTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 18/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <UIKit/UIKit.h>

@interface JBTeamStatsTableViewCell : UITableViewCell

@property (nonatomic, weak) JBTeam *team;

@property (nonatomic, weak) IBOutlet UILabel *raisedAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *raisedLabel;
@property (nonatomic, weak) IBOutlet UILabel *countriesAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *countriesLabel;
@property (nonatomic, weak) IBOutlet UILabel *transportAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *transportLabel;
@property (nonatomic, weak) IBOutlet UILabel *challengesAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *challengesLabel;

@end
