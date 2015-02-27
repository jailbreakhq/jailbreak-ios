//
//  JBFeedDonateTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "UIColor+JBAdditions.h"
#import "JBFeedDonateTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBFeedDonateTableViewCell

#pragma mark - Initialisers

- (void)awakeFromNib
{
    [self setup];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

#pragma mark - Helper Methods

- (void)setup
{
    [self.button addTarget:self action:@selector(didTapDonateButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureCellWithPost:(JBPost *)post
{
    self.post = post;
    
    if (post.donate.limitedTeam)
    {
        self.avatarImageView.progressColor = post.donate.limitedTeam.universityColor;
        [self.avatarImageView sd_setImageWithProgressAndURL:post.donate.limitedTeam.avatarURL];
        self.titleLabel.text = post.donate.limitedTeam.membersNames;
        self.button.backgroundColor = post.donate.limitedTeam.universityColor;
    }
    else
    {
        self.avatarImageView.image = [UIImage imageNamed:@"jailbreakLogo"];
        self.titleLabel.text = @"Jailbreak HQ";
        self.button.backgroundColor = [UIColor colorWithHexString:@"#B41C21"];
    }
    
    self.bodyLabel.text = post.donate.donateDescription;
    self.button.titleLabel.textColor = [UIColor whiteColor];
    [self.button setTitle:post.donate.buttonText forState:UIControlStateNormal];
}

- (void)didTapDonateButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapDonateButtonWithTeam:)])
    {
        [self.delegate didTapDonateButtonWithTeam:self.post.donate.limitedTeam];
    }
}

@end
