//
//  JBTeamAboutTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 17/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeamAboutTableViewCell.h"

@implementation JBTeamAboutTableViewCell

- (void)setTeam:(JBTeam *)team
{
    _team = team;
    
    self.aboutHeadingLabel.text = [NSString stringWithFormat:@"About %@", self.team.membersNames];
    self.aboutBodyLabel.text = self.team.about;
}

@end
