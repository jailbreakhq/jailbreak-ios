//
//  JBFeedDonateTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import <UIKit/UIKit.h>
#import "JBPostDonate.h"

@protocol JBFeedDonateTableViewCellDelegate <NSObject>

- (void)didTapDonateButtonWithTeam:(JBTeam *)team;

@end

@interface JBFeedDonateTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *bodyLabel;
@property (nonatomic, weak) IBOutlet UIButton *button;

@property (nonatomic, weak) JBPost *post;
@property (nonatomic, weak) id <JBFeedDonateTableViewCellDelegate> delegate;

- (void)configureCellWithPost:(JBPost *)post;

@end
