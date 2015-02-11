//
//  JBTestProfileViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 09/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "UIImage+JBAdditions.h"
#import "JBYouTubeView.h"
#import "JBTestProfileViewController.h"
#import <XCDYouTubeKit.h>

@interface JBTestProfileViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *blurImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *namesLabel;
@property (nonatomic, weak) IBOutlet JBYouTubeView *videoView;

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@end

@implementation JBTestProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.videoView.playButton addGestureRecognizer:tapGesture];
    
    // YouTube video thumbnail
    if (self.team.videoID)
    {
        self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.team.videoID];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:self.videoPlayerViewController];
        [defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayerViewController.moviePlayer];
    }
    else
    {
        
    }
    
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:self.team.avatarURL
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                     if (image)
                                                     {
                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                             UIImage *blurImage = [image resizedImage:CGSizeMake(image.size.width/2.0, image.size.height/2.0) interpolationQuality:kCGInterpolationNone];
                                                             // Blur image
                                                             blurImage = [blurImage blurredImageWithRadius:10 iterations:3 tintColor:[UIColor colorWithWhite:0.0 alpha:0.25]];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 weakSelf.blurImageView.image = blurImage;
                                                             });
                                                         });
                                                     }
                                                  }];
    
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarLargeURL completed:nil];
    self.namesLabel.text = self.team.membersNames;
}

- (void)videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
    XCDYouTubeVideo *video = notification.userInfo[XCDYouTubeVideoUserInfoKey];
    
    self.videoView.titleLabel.text = video.title;
    [self.videoView.thumbnailImageView sd_setImageWithURL:video.largeThumbnailURL ?: video.mediumThumbnailURL ?: video.smallThumbnailURL];
}

- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    
}

- (void)playVideo:(UITapGestureRecognizer *)sender
{
    [self presentMoviePlayerViewControllerAnimated:self.videoPlayerViewController];
}

@end
