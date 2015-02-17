//
//  JBYouTubeView.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 10/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBYouTubeView.h"

@implementation JBYouTubeView

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

- (void)setup
{
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    playButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playButton = playButton;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPlayButton)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.playButton addGestureRecognizer:tapGesture];
    
    UIImageView *thumbnailImageView = [UIImageView new];
    thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    thumbnailImageView.clipsToBounds = YES;
    thumbnailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumbnailImageView = thumbnailImageView;
    
    [self addSubview:self.thumbnailImageView];
    [self addSubview:self.playButton];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:playButton
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:playButton
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailImageView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailImageView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailImageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailImageView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void)didTapPlayButton
{
    if ([self.delegate respondsToSelector:@selector(didTapPlayButton)])
    {
        [self.delegate didTapPlayButton];
    }
}

@end
