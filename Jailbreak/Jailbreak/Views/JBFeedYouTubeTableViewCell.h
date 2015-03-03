//
//  JBFeedYouTubeTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import "JBYouTubeView.h"
#import "JBFeedBaseTableViewCell.h"
#import <XCDYouTubeVideoPlayerViewController.h>

@interface JBFeedYouTubeTableViewCell : JBFeedBaseTableViewCell

@property (nonatomic, weak) IBOutlet JBYouTubeView *youTubeView;

@property (nonatomic, weak) JBPost *post;
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@end
