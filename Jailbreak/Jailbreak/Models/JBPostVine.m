//
//  JBPostVine.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostVine.h"
#import "JBAPIManager.h"

@implementation JBPostVine

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.vineDescription = [aDecoder decodeObjectForKey:@"vineDescription"];
        self.vineURL = [aDecoder decodeObjectForKey:@"vineURL"];
        self.thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
        self.remoteVideoURL = [aDecoder decodeObjectForKey:@"remoteVideoURL"];
//        self.localVideoURL = [aDecoder decodeObjectForKey:@"localVideoURL"];
        self.authorUsername = [aDecoder decodeObjectForKey:@"authorUsername"];
        self.authorURL = [aDecoder decodeObjectForKey:@"authorURL"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
        self.authorPhotoURL = [aDecoder decodeObjectForKey:@"authorPhotoURL"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.vineDescription forKey:@"vineDescription"];
    [aCoder encodeObject:self.vineURL forKey:@"vineURL"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
    [aCoder encodeObject:self.remoteVideoURL forKey:@"remoteVideoURL"];
//    [aCoder encodeObject:self.localVideoURL forKey:@"localVideoURL"];
    [aCoder encodeObject:self.authorUsername forKey:@"authorUsername"];
    [aCoder encodeObject:self.authorURL forKey:@"authorURL"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
    [aCoder encodeObject:self.authorPhotoURL forKey:@"authorPhotoURL"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.vineDescription = json[@"description"];
        self.vineURL = [NSURL URLWithString:json[@"url"]];
        self.thumbnailURL = [NSURL URLWithString:json[@"thumbnailUrl"]];
        self.authorUsername = json[@"authorName"];
        self.authorURL = [NSURL URLWithString:json[@"authorUrl"]];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        self.authorPhotoURL = [NSURL URLWithString:json[@"authorPhotoUrl"]];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[json[@"time"] unsignedIntegerValue]];
        self.remoteVideoURL = [NSURL URLWithString:json[@"videoUrl"]];
        
        if (json[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:json[@"team"]];
        }
        
        if (!self.remoteVideoURL && !self.authorPhotoURL)
        {
            NSString *vinePostId = self.vineURL.absoluteString;
            vinePostId =  [vinePostId componentsSeparatedByString:@"/"].lastObject;
            
            [[JBAPIManager manager] GET:[NSString stringWithFormat:@"https://api.vineapp.com/timelines/posts/s/%@", vinePostId]
                             parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSString *remoteVideoURLString = [responseObject[@"data"][@"records"] firstObject][@"videoUrl"];
                                    NSString *authorPhotoURLString = [responseObject[@"data"][@"records"] firstObject][@"avatarUrl"];
                                    self.remoteVideoURL = [NSURL URLWithString:remoteVideoURLString];
                                    self.authorPhotoURL = [NSURL URLWithString:authorPhotoURLString];
                                } failure:nil];
        }
    }
    
    return self;
}

@end
