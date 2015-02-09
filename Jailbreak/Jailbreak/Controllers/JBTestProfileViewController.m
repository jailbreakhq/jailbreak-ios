//
//  JBTestProfileViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 09/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "YTPlayerView.h"
#import "UIImage+FXBlur.h"
#import "JBTestProfileViewController.h"

@interface JBTestProfileViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *blurImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *namesLabel;
@property (nonatomic, weak) IBOutlet YTPlayerView *videoView;

@end

@implementation JBTestProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.team.videoID) [self.videoView loadWithVideoId:self.team.videoID];
    
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:self.team.avatarURL
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                     if (image)
                                                     {
                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                             // Blur image
                                                             UIImage *blurImage = [image blurredImageWithRadius:10 iterations:3 tintColor:[UIColor colorWithWhite:0.0 alpha:0.25]];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 weakSelf.blurImageView.image = blurImage;
                                                             });
                                                         });
                                                     }
                                                  }];
    
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarLargeURL completed:nil];
    self.namesLabel.text = self.team.membersNames;
}

@end
