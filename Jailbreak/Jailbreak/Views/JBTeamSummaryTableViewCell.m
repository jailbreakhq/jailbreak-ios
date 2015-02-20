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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnImageView)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    self.avatarImageView.progressColor = self.team.universityColor;
    [self.avatarImageView addGestureRecognizer:tapGestureRecognizer];
    self.avatarImageView.userInteractionEnabled = NO;
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarLargeURL
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                  if (!image)
                                                  {
                                                      self.avatarPlaceholderLabel.text = [self abbreviationForNames:self.team.membersNames];
                                                  }
                                                  else
                                                  {
                                                      self.avatarImageView.userInteractionEnabled = YES;
                                                  }
                                              }];
    self.teamMemberNamesLabel.text = self.team.membersNames;
    self.teamRankLabel.text = @"42nd Place";
    self.teamUniversityLabel.text = self.team.universityString;
    self.teamUniversityLabel.textColor = self.team.universityColor;
    self.teamTaglineLabel.text = self.team.tagLine;
}

- (void)didTapOnImageView
{
    if ([self.delegate respondsToSelector:@selector(didTapAvatarImageView:)])
    {
        [self.delegate didTapAvatarImageView:self.avatarImageView];
    }
}

- (NSString *)abbreviationForNames:(NSString *)string
{
    NSArray *names = [[string stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"&"];
    return [NSString stringWithFormat:@"%@&%@", [names[0] substringToIndex:1], [names[1] substringToIndex:1]];
}

@end
