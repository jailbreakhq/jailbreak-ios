//
//  JBTestProfileViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 09/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "YTPlayerView.h"
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
    
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarLargeURL
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                  self.blurImageView.image = self.avatarImageView.image;
                                              }];
    self.namesLabel.text = self.team.membersNames;
}

@end
