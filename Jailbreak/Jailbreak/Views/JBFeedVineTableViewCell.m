//
//  JBFeedVineTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <AFURLSessionManager.h>
#import "JBFeedVineTableViewCell.h"

@implementation JBFeedVineTableViewCell

#pragma mark - Initialisers

- (void)awakeFromNib
{
    [self setup];
}

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

#pragma mark - Helper Methods

- (void)playOrStopVine
{
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying)
    {
        [self.moviePlayerController pause];
        self.thumbnailImageView.alpha = 1.0;
        self.thumbnailImageView.hidden = NO;
        self.playButtonImageView.alpha = 1.0;
        return;
    }
    
    if (!self.post.vine.localVideoURL)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.post.vine.remoteVideoURL];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"Error: %@ %@", error.localizedDescription, error.localizedRecoverySuggestion);
            NSLog(@"File downloaded to: %@", filePath);
            self.post.vine.localVideoURL = filePath;
            [self.loadingIndicatorView stopAnimating];
            [self play];
        }];
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.playButtonImageView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [self.loadingIndicatorView startAnimating];
                             [downloadTask resume];
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.playButtonImageView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [self play];
                         }];
    }
}

- (void)play
{
    self.moviePlayerController.contentURL = self.post.vine.localVideoURL;
    [self.moviePlayerController play];

    [UIView animateWithDuration:0.4
                     animations:^{
                         self.thumbnailImageView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         self.thumbnailImageView.hidden = YES;
                     }];
}

- (void)configureCellWithPost:(JBPost *)post
{
    [super configureCellWithPost:post];
    
    self.thumbnailImageView.alpha = 1.0;
    self.thumbnailImageView.hidden = NO;
    self.playButtonImageView.alpha = 1.0;
    self.post = post;
}

- (void)setup
{
    self.loadingIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave];
    self.loadingIndicatorView.hidesWhenStopped = YES;
    self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingIndicatorView.color = [UIColor whiteColor];
    [self.loadingIndicatorView stopAnimating];
    [self.videoContrainerView addSubview:self.loadingIndicatorView];
    
    [self.videoContrainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.videoContrainerView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0]];
    
    [self.videoContrainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.videoContrainerView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0]];
    
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:nil];
    self.moviePlayerController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.moviePlayerController.shouldAutoplay = NO;
    self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    [self.moviePlayerController prepareToPlay];

    [self.videoContrainerView insertSubview:self.moviePlayerController.view atIndex:0];
    [self.videoContrainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.moviePlayerController.view
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.videoContrainerView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:0.0]];
    
    [self.videoContrainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.moviePlayerController.view
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.videoContrainerView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0.0]];
    
    [self.videoContrainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.moviePlayerController.view
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.videoContrainerView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:0.0]];
    
    [self.videoContrainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.moviePlayerController.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.videoContrainerView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0.0]];
}

@end
