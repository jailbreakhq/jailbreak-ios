//
//  JBTeamSummaryTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 17/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <UIKit/UIKit.h>

@protocol JBTeamSummaryTableViewCellDelegate <NSObject>

- (void)didTapAvatarImageView:(UIImageView *)avatarImageView;

@end
@interface JBTeamSummaryTableViewCell : UITableViewCell

@property (nonatomic, weak) JBTeam *team;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *avatarPlaceholderLabel;
@property (nonatomic, weak) IBOutlet UILabel *teamMemberNamesLabel;
@property (nonatomic, weak) IBOutlet UILabel *teamRankLabel;
@property (nonatomic, weak) IBOutlet UILabel *teamUniversityLabel;
@property (nonatomic, weak) IBOutlet UILabel *teamTaglineLabel;

@property (nonatomic, weak) id <JBTeamSummaryTableViewCellDelegate> delegate;

@end
