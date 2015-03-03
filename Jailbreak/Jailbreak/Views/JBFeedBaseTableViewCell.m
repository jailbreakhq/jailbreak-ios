//
//  JBFeedBaseTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <NSDate+DateTools.h>
#import "UIColor+JBAdditions.h"
#import "JBFeedBaseTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBFeedBaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                              interval:1.0
                                                target:self
                                              selector:@selector(updateTimeAgoLabel)
                                              userInfo:nil
                                               repeats:YES];
    
    // To update while scrolling the table view
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)configureCellWithPost:(JBPost *)post
{
    self.post = post;
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
        case JBPostTypeYouTube:
            self.socialNetworkImageView.image = [UIImage imageNamed:@"youTubeLogo"];
            self.bodyLabel.text = post.youtube.youTubeDescription;
    }
    
    if (post.limitedTeam)
    {
        self.titleLabel.text = post.limitedTeam.membersNames;
        self.avatarImageView.progressColor = post.limitedTeam.universityColor;
        [self.avatarImageView sd_setImageWithProgressAndURL:post.limitedTeam.avatarURL];
    }
    else
    {
        self.avatarImageView.progressColor = [UIColor colorWithHexString:@"#B41C21"];

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
                [self.avatarImageView sd_setImageWithProgressAndURL:post.facebook.authorPhotoURL];
                break;
            case JBPostTypeInstagram:
                self.titleLabel.text = [NSString stringWithFormat:@"@%@", post.instagram.authorUsername];
                [self.avatarImageView sd_setImageWithProgressAndURL:post.instagram.authorPhotoURL];
                break;
            case JBPostTypeTwitter:
                self.titleLabel.text = [NSString stringWithFormat:@"@%@", post.twitter.twitterUsername];
                [self.avatarImageView sd_setImageWithProgressAndURL:post.twitter.twitterUserPhotoURL];
                break;
            case JBPostTypeVine:
                self.titleLabel.text = [NSString stringWithFormat:@"@%@", post.vine.authorUsername];
                [self.avatarImageView sd_setImageWithProgressAndURL:post.vine.authorPhotoURL];
                break;
            case JBPostTypeYouTube:
                self.titleLabel.text = [NSString stringWithFormat:@"@%@", post.youtube.authorUsername];
                [self.avatarImageView sd_setImageWithProgressAndURL:post.youtube.authorPhotoURL];
                break;
        }
    }
}

- (void)updateTimeAgoLabel
{
    self.timeLabel.text = self.post.createdTime ? [self.post.createdTime shortTimeAgoSinceNow] : @"";
}

@end
