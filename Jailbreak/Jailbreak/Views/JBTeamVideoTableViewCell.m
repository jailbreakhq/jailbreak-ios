//
//  JBTeamVideoTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 17/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "JBTeamVideoTableViewCell.h"

@implementation JBTeamVideoTableViewCell

- (void)setYouTubeVideoId:(NSString *)youTubeVideoId
{
    _youTubeVideoId = youTubeVideoId;
    
    NSURL *hdThumbnail = [NSURL URLWithString:[NSString stringWithFormat:@"http://i3.ytimg.com/vi/%@/maxresdefault.jpg", self.youTubeVideoId]];
    NSURL *sdThumbnail = [NSURL URLWithString:[NSString stringWithFormat:@"http://i3.ytimg.com/vi/%@/sddefault.jpg", self.youTubeVideoId]];
    
    [self.youTubeView.thumbnailImageView sd_setImageWithURL:hdThumbnail
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                      if (!image)
                                                      {
                                                          [self.youTubeView.thumbnailImageView sd_setImageWithURL:sdThumbnail];
                                                      }
                                                  }];
}

@end
