//
//  JBFeedVineTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <AFURLSessionManager.h>
#import "JBFeedVineTableViewCell.h"

@interface JBFeedVineTableViewCell ()

@property (nonatomic, strong) id observer;

@end

@implementation JBFeedVineTableViewCell

#pragma mark - Initialisers

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

#pragma mark - Helper Methods

- (void)play
{
    self.moviePlayerController.contentURL = self.post.vine.localVideoURL;
    [self.moviePlayerController play];

    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.thumbnailImageView.alpha = 0.0;
                         self.playButton.alpha = 0.0;
                     } completion:nil];
}

- (void)stop
{
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.thumbnailImageView.alpha = 1.0;
                         self.playButton.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self.moviePlayerController stop];
                     }];
}

- (void)configureCellWithPost:(JBPost *)post
{
    [super configureCellWithPost:post];
    
    [self stop];
    self.post = post;
}

- (void)setup
{
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:nil];
    self.moviePlayerController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.moviePlayerController.shouldAutoplay = NO;
    self.moviePlayerController.controlStyle = MPMovieControlStyleNone;

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
    
    UIImageView *imageView = [UIImageView new];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumbnailImageView = imageView;
    
    [self.moviePlayerController.view insertSubview:self.thumbnailImageView atIndex:self.moviePlayerController.view.subviews.count];
    [self.moviePlayerController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnailImageView
                                                                                attribute:NSLayoutAttributeLeading
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.moviePlayerController.view
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.0
                                                                                 constant:0.0]];
    
    [self.moviePlayerController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnailImageView
                                                                                attribute:NSLayoutAttributeTrailing
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.moviePlayerController.view
                                                                                attribute:NSLayoutAttributeRight
                                                                               multiplier:1.0
                                                                                 constant:0.0]];
    
    [self.moviePlayerController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnailImageView
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.moviePlayerController.view
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.0
                                                                                 constant:0.0]];
    
    [self.moviePlayerController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnailImageView
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.moviePlayerController.view
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.0
                                                                                 constant:0.0]];
    
    self.loadingIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave];
    self.loadingIndicatorView.hidesWhenStopped = YES;
    self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingIndicatorView.color = [UIColor whiteColor];
    [self.loadingIndicatorView stopAnimating];
    [self.moviePlayerController.view addSubview:self.loadingIndicatorView];
    
    [self.moviePlayerController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                                                attribute:NSLayoutAttributeCenterX
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.moviePlayerController.view
                                                                                attribute:NSLayoutAttributeCenterX
                                                                               multiplier:1.0
                                                                                 constant:0.0]];
    
    [self.moviePlayerController.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                                                attribute:NSLayoutAttributeCenterY
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.moviePlayerController.view
                                                                                attribute:NSLayoutAttributeCenterY
                                                                               multiplier:1.0
                                                                                 constant:0.0]];

    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackStateDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      switch (self.moviePlayerController.playbackState)
                                                      {
                                                          case MPMoviePlaybackStateInterrupted:
                                                          case MPMoviePlaybackStateSeekingBackward:
                                                          case MPMoviePlaybackStateSeekingForward:
                                                          case MPMoviePlaybackStatePlaying:
                                                              break;
                                                          case MPMoviePlaybackStatePaused:
                                                          {
                                                              [UIView animateWithDuration:0.3
                                                                                    delay:0.0
                                                                                  options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                                                                               animations:^{
                                                                                   self.playButton.alpha = 1.0;
                                                                               } completion:nil];
                                                              break;
                                                          }
                                                          case MPMoviePlaybackStateStopped:
                                                          {
                                                              [UIView animateWithDuration:0.3
                                                                                    delay:0.0
                                                                                  options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                                                                               animations:^{
                                                                                   self.thumbnailImageView.alpha = 1.0;
                                                                                   self.playButton.alpha = 1.0;
                                                                               } completion:nil];
                                                              break;
                                                          }
                                                      }
                                                  }];
}
- (IBAction)didTapPlayButton:(UIButton *)sender
{
    // Not downloaded so download
    if (!self.post.vine.localVideoURL)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.post.vine.remoteVideoURL];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            self.post.vine.localVideoURL = filePath;
            [self.loadingIndicatorView stopAnimating];
            [self play];
        }];
        
        [self.loadingIndicatorView startAnimating];
        self.playButton.alpha = 0.0;
        [downloadTask resume];
    }
    else
    {
        [self play];
    }
}

@end
