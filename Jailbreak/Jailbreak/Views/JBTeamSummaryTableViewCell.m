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
    
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarURL
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                  if (!image)
                                                  {
                                                      self.avatarPlaceholderLabel.text = [self abbreviationForNames:self.team.membersNames];
                                                  }
                                              }];
    self.teamMemberNamesLabel.text = self.team.membersNames;
    self.teamRankLabel.text = @"42nd Place";
    self.teamUniversityLabel.text = self.team.universityString;
    self.teamUniversityLabel.textColor = self.team.universityColor;
    self.teamTaglineLabel.text = self.team.tagLine;
}

- (NSString *)abbreviationForNames:(NSString *)string
{
    NSArray *names = [[string stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"&"];
    return [NSString stringWithFormat:@"%@&%@", [names[0] substringToIndex:1], [names[1] substringToIndex:1]];
}

@end
