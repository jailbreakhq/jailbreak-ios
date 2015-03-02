//
//  JBFeedBaseTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBFeedImageTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBFeedImageTableViewCell

#pragma mark - Initialisers

- (void)awakeFromNib
{
    [self configure];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self configure];
    }
    
    return self;
}

#pragma mark - Helper Methods

- (void)configureCellWithPost:(JBPost *)post
{
    [super configureCellWithPost:post];
    
    switch (post.postType)
    {
        case JBPostTypeUndefined:
        case JBPostTypeCheckin:
        case JBPostTypeDonate:
        case JBPostTypeLink:
        case JBPostTypeYouTube:
            self.thumbnailImageView.image = nil;
            break;
        case JBPostTypeFacebook:
            [self.thumbnailImageView sd_setImageWithProgressAndURL:post.facebook.photoURL];
            break;
        case JBPostTypeInstagram:
            [self.thumbnailImageView sd_setImageWithProgressAndURL:post.instagram.thumbnailURL];
            break;
        case JBPostTypeTwitter:
            [self.thumbnailImageView sd_setImageWithProgressAndURL:post.twitter.photoURL];
            break;
        case JBPostTypeVine:
            [self.thumbnailImageView sd_setImageWithProgressAndURL:post.vine.thumbnailURL];
            break;
    }
    
    if (post.limitedTeam)
    {
        self.thumbnailImageView.progressColor = post.limitedTeam.universityColor;
    }
}

- (void)configure
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnThumbnailImageView)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    self.thumbnailImageView.userInteractionEnabled = YES;
    [self.thumbnailImageView addGestureRecognizer:tapGestureRecognizer];}

- (void)didTapOnThumbnailImageView
{
    if ([self.delegate respondsToSelector:@selector(feedImageTableViewCell:didTapOnThumbnailImageView:)])
    {
        [self.delegate feedImageTableViewCell:self didTapOnThumbnailImageView:self.thumbnailImageView];
    }
}

@end
