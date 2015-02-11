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
    UIView *dimmerView = [UIView new];
    dimmerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    dimmerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    playButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playButton = playButton;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel = titleLabel;
    
    UIImageView *thumbnailImageView = [UIImageView new];
    thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    thumbnailImageView.clipsToBounds = YES;
    thumbnailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumbnailImageView = thumbnailImageView;
    
    [self addSubview:self.thumbnailImageView];
    [dimmerView addSubview:self.titleLabel];
    [self addSubview:dimmerView];
    [self addSubview:self.playButton];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:dimmerView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:40.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:dimmerView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:dimmerView
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeLeading
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:dimmerView
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.0
                                                            constant:0.0]];
    
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
    
    [dimmerView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:dimmerView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:15.0]];
    
    [dimmerView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:dimmerView
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.0
                                                            constant:15.0]];
    
    [dimmerView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:dimmerView
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

@end
