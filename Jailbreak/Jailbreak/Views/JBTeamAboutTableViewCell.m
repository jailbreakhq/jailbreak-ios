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

- (CGFloat)heightForBodyLabelWithText:(NSString *)text
{
    // Just taken from Storyboard, height + top / bottom margins for everything except multi-line label height...
    CGFloat magicNumber = 10 + 21 + 5 + 15;
    CGSize bodyLabelSize = [text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName: self.aboutBodyLabel.font}
                                                                  context:nil].size;
    
    return magicNumber + bodyLabelSize.height + 5;
}

@end
