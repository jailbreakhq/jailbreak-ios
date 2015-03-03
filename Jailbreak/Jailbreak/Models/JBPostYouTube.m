//
//  JBPostYouTube.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostYouTube.h"
#import <SDWebImageManager.h>

@implementation JBPostYouTube

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.youTubeDescription = [aDecoder decodeObjectForKey:@"youTubeDescription"];
        self.videoURL = [aDecoder decodeObjectForKey:@"videoURL"];
        self.videoId = [aDecoder decodeObjectForKey:@"videoId"];
        self.authorUsername = [aDecoder decodeObjectForKey:@"authorUsername"];
        self.authorURL = [aDecoder decodeObjectForKey:@"authorURL"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
        self.authorPhotoURL = [aDecoder decodeObjectForKey:@"authorPhotoURL"];
        self.thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.youTubeDescription forKey:@"youTubeDescription"];
    [aCoder encodeObject:self.videoURL forKey:@"videoURL"];
    [aCoder encodeObject:self.videoId forKey:@"videoId"];
    [aCoder encodeObject:self.authorUsername forKey:@"authorUsername"];
    [aCoder encodeObject:self.authorURL forKey:@"authorURL"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
    [aCoder encodeObject:self.authorPhotoURL forKey:@"authorPhotoURL"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.title = json[@"title"];
        self.youTubeDescription = json[@"description"];
        self.videoURL = [NSURL URLWithString:json[@"url"]];
        self.videoId = [self.videoURL.absoluteString componentsSeparatedByString:@"?v="].lastObject;
        self.authorUsername = json[@"authorName"];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[json[@"time"] unsignedIntegerValue]];
        self.authorPhotoURL = [NSURL URLWithString:json[@"authorPhotoUrl"]];
        
        if (json[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:json[@"team"]];
        }
    }
    
    return self;
}

+ (void)getThumbnailURLForYouTubeVideoWithId:(NSString *)videoId completionHandler:(void (^)(NSURL *))completionHandler
{
    NSURL *smallThumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/default.jpg", videoId]];
    NSURL *mediumThumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/sddefault.jpg", videoId]];
    NSURL *largeThumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://i.ytimg.com/vi/%@/maxresdefault.jpg", videoId]];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:largeThumbnailURL options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (error)
        {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:mediumThumbnailURL options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (error)
                {
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:smallThumbnailURL options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        completionHandler(smallThumbnailURL);
                    }];
                }
                else
                {
                    completionHandler(mediumThumbnailURL);
                }
            }];
        }
        else
        {
            completionHandler(largeThumbnailURL);
        }
    }];
}

@end
