//
//  JBFeedBaseTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <NSDate+DateTools.h>
#import "JBFeedBaseTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBFeedBaseTableViewCell

- (void)configureCellWithPost:(JBPost *)post
{
    self.titleLabel.text = post.teamName;
    self.bodyLabel.text = post.body;
    self.timeLabel.text = [post.timeCreated shortTimeAgoSinceNow];
    [self.avatarImageView sd_setImageWithProgressAndURL:post.teamAvatarURL];
    
    switch (post.socialNetwork)
    {
        case JBPostSocialNetworkFacebook:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"facebookLogo"];
            break;
        case JBPostSocialNetworkInstagram:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"instagramLogo"];
            break;
        case JBPostSocialNetworkTwitter:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"twitterLogo"];
            break;
        case JBPostSocialNetworkVine:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"vineLogo"];
            break;
    }
}

@end
