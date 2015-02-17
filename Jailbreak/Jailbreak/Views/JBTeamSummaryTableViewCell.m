//
//  JBTeamSummaryTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 17/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeamSummaryTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBTeamSummaryTableViewCell

- (void)setTeam:(JBTeam *)team
{
    _team = team;
    
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarURL];
    self.teamMemberNamesLabel.text = self.team.membersNames;
    self.teamRankLabel.text = @"42nd Place";
    self.teamUniversityLabel.text = self.team.universityString;
    self.teamUniversityLabel.textColor = self.team.universityColor;
    self.teamTaglineLabel.text = self.team.tagLine;
}

@end
