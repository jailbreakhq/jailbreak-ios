//
//  JBFeedVineTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <RTSpinKitView.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JBFeedImageTableViewCell.h"

@interface JBFeedVineTableViewCell : JBFeedImageTableViewCell

@property (nonatomic, weak) IBOutlet UIView *videoContrainerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;

@property (nonatomic, strong) RTSpinKitView *loadingIndicatorView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, weak) JBPost *post;

@end
