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
    self.timeLabel.text = post.createdTime ? [post.createdTime shortTimeAgoSinceNow] : @"";

    switch (post.postType)
    {
        case JBPostTypeUndefined:
            break;
        case JBPostTypeCheckin:
            self.socialNetworkImageView.image = nil;
            self.bodyLabel.text = post.checkin.status;
            break;
        case JBPostTypeDonate:
            break;
        case JBPostTypeFacebook:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"facebookLogo"];
            self.bodyLabel.text = post.facebook.facebookPostBody;
            break;
        case JBPostTypeInstagram:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"instagramLogo"];
            self.bodyLabel.text = post.instagram.instagramDescription;
            break;
        case JBPostTypeLink:
            self.socialNetworkImageView.image = nil;
            self.bodyLabel.text = post.link.linkDescription;
            break;
        case JBPostTypeTwitter:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"twitterLogo"];
            self.bodyLabel.text = post.twitter.tweetBodyPlain;
            break;
        case JBPostTypeVine:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"vineLogo"];
            self.bodyLabel.text = post.vine.vineDescription;
            break;
    }
    
    if (post.limitedTeam)
    {
        self.titleLabel.text = post.limitedTeam.membersNames;
        self.avatarImageView.progressColor = post.limitedTeam.universityColor;
        [self.avatarImageView sd_setImageWithProgressAndURL:post.limitedTeam.avatarURL];
    }
    else
    {
        switch (post.postType)
        {
            case JBPostTypeUndefined:
            case JBPostTypeCheckin:
            case JBPostTypeDonate:
            case JBPostTypeLink:
                self.titleLabel.text = @"";
                self.avatarImageView.image = nil;
                break;
            case JBPostTypeFacebook:
                self.titleLabel.text = @"";
                self.avatarImageView.image = nil;
                break;
            case JBPostTypeInstagram:
                self.titleLabel.text = [NSString stringWithFormat:@"@%@", post.instagram.authorUsername];
                self.avatarImageView.image = nil;
                break;
            case JBPostTypeTwitter:
                self.titleLabel.text = [NSString stringWithFormat:@"@%@", post.twitter.twitterUsername];
                [self.avatarImageView sd_setImageWithProgressAndURL:post.twitter.twitterUserPhotoURL];
                break;
            case JBPostTypeVine:
                self.titleLabel.text = [NSString stringWithFormat:@"@%@", post.vine.authorUsername];
                self.avatarImageView.image = nil;
                break;
        }
    }
}

@end
