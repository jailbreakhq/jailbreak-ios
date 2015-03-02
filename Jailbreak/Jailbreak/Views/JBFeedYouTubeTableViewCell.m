//
//  JBFeedYouTubeTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <XCDYouTubeVideo.h>
#import "JBFeedYouTubeTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"
#import <XCDYouTubeVideoPlayerViewController.h>

@interface JBFeedYouTubeTableViewCell ()

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@end

@implementation JBFeedYouTubeTableViewCell

- (void)awakeFromNib
{
    [self setup];
}

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
    self.videoPlayerViewController.videoIdentifier = self.post.youtube.videoId;
    [self.youTubeView.thumbnailImageView sd_setImageWithURL:self.post.youtube.thumbnailURL];
}

- (void)setup
{
    void (^notificationBlock)(NSNotification *note) = ^void(NSNotification *note)
    {
        NSLog(@"!!");
        if (!self.post.youtube.thumbnailURL)
        {
            XCDYouTubeVideo *video = (XCDYouTubeVideo *)note.userInfo[XCDYouTubeVideoUserInfoKey];
            self.post.youtube.thumbnailURL = video.largeThumbnailURL ?: video.mediumThumbnailURL ?: video.smallThumbnailURL;
            [[SDWebImageManager sharedManager] downloadImageWithURL:self.post.youtube.thumbnailURL
                                                            options:nil
                                                           progress:nil
                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                              [self.youTubeView.thumbnailImageView sd_setImageWithURL:self.post.youtube.thumbnailURL];
                                                          }];
        };
    };
    
    [[NSNotificationCenter defaultCenter] addObserverForName:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:notificationBlock];
}

@end
