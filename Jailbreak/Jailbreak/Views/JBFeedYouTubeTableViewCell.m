//
//  JBFeedYouTubeTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostYouTube.h"
#import "JBFeedYouTubeTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@interface JBFeedYouTubeTableViewCell () <JBYouTubeViewDelegate>

@end

@implementation JBFeedYouTubeTableViewCell

- (XCDYouTubeVideoPlayerViewController *)videoPlayerViewController
{
    if (!_videoPlayerViewController)
    {
        _videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.post.youtube.videoId];
    }
    
    return _videoPlayerViewController;
}

- (void)configureCellWithPost:(JBPost *)post
{
    [super configureCellWithPost:post];
    
    self.post = post;
    self.youTubeView.delegate = self;
    self.videoPlayerViewController.videoIdentifier = self.post.youtube.videoId;
    
    if (self.post.youtube.thumbnailURL)
    {
        [self.youTubeView.thumbnailImageView sd_setImageWithURL:self.post.youtube.thumbnailURL];
    }
    else
    {
        [JBPostYouTube getThumbnailURLForYouTubeVideoWithId:self.post.youtube.videoId completionHandler:^(NSURL *thumbnailURL) {
            self.post.youtube.thumbnailURL = thumbnailURL;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.youTubeView.thumbnailImageView sd_setImageWithURL:self.post.youtube.thumbnailURL];
            });
        }];
    }
}

- (void)didTapPlayButton
{
    [self.window.rootViewController presentMoviePlayerViewControllerAnimated:self.videoPlayerViewController];
}

@end
