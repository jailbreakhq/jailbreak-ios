//
//  JBYouTubeView.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 10/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JBYouTubeViewDelegate <NSObject>

- (void)didTapPlayButton;

@end

@interface JBYouTubeView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *playButton;
@property (nonatomic, weak) UIImageView *thumbnailImageView;

@property (nonatomic, weak) id <JBYouTubeViewDelegate> delegate;

@end
