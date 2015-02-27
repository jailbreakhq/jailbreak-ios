//
//  JBFeedLinkTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "UIColor+JBAdditions.h"
#import "JBFeedLinkTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBFeedLinkTableViewCell

- (void)awakeFromNib
{
    [self.button addTarget:self action:@selector(didTapDonateButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Helper Methods

- (void)configureCellWithPost:(JBPost *)post
{
    self.post = post;
    
    self.photoImageView.progressColor = [UIColor colorWithHexString:@"#B41C21"];
    [self.photoImageView sd_setImageWithURL:post.link.photoURL];
    self.bodyLabel.text = post.link.linkDescription;
    self.button.backgroundColor = [UIColor colorWithHexString:@"#B41C21"];
    [self.button setTitle:post.link.linkText forState:UIControlStateNormal];
}

- (void)didTapDonateButton:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:self.post.link.url];
}

@end
