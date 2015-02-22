//
//  JBFeedBaseTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBFeedImageTableViewCell.h"

@implementation JBFeedImageTableViewCell

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
