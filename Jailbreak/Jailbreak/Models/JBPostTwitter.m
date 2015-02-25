//
//  JBPostTwitter.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostTwitter.h"

@implementation JBPostTwitter

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.tweetId = [aDecoder decodeIntegerForKey:@"tweetId"];
        self.tweetBodyPlain = [aDecoder decodeObjectForKey:@"tweetBodyPlain"];
        self.tweetBodyHTML = [aDecoder decodeObjectForKey:@"tweetBodyHTML"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
        self.photoUrl = [aDecoder decodeObjectForKey:@"photoUrl"];
        self.inReplyToTwitterUsername = [aDecoder decodeObjectForKey:@"inReplyToTwitterUsername"];
        self.twitterUserId = [aDecoder decodeIntegerForKey:@"twitterUserId"];
        self.twitterUsername = [aDecoder decodeObjectForKey:@"twitterUsername"];
        self.twitterUserPhotoURL = [aDecoder decodeObjectForKey:@"twitterUserPhotoURL"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInteger:self.tweetId forKey:@"tweetId"];
    [aCoder encodeObject:self.tweetBodyPlain forKey:@"tweetBodyPlain"];
    [aCoder encodeObject:self.tweetBodyHTML forKey:@"tweetBodyHTML"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
    [aCoder encodeObject:self.photoUrl forKey:@"photoUrl"];
    [aCoder encodeObject:self.inReplyToTwitterUsername forKey:@"inReplyToTwitterUsername"];
    [aCoder encodeInteger:self.twitterUserId forKey:@"twitterUserId"];
    [aCoder encodeObject:self.twitterUsername forKey:@"twitterUsername"];
    [aCoder encodeObject:self.twitterUserPhotoURL forKey:@"twitterUserPhotoURL"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super initWithJSON:json];
    
    NSDictionary *twitterJSON = json[@"twitter"];
    
    if (self)
    {
        self.tweetId = [twitterJSON[@"tweetId"] unsignedIntegerValue];
        self.tweetBodyPlain = twitterJSON[@"tweet"];
        self.tweetBodyHTML = twitterJSON[@"tweetHtml"];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[twitterJSON[@"time"] doubleValue]];
        self.photoUrl = [NSURL URLWithString:twitterJSON[@"photoUrl"]];
        self.inReplyToTwitterUsername = twitterJSON[@"inReplyTo"];
        self.twitterUserId = [twitterJSON[@"twitterUserId"] unsignedIntegerValue];
        self.twitterUsername = twitterJSON[@"twitterUserName"];
        self.twitterUserPhotoURL = [NSURL URLWithString:twitterJSON[@"twitterUserPhoto"]];
        self.teamId = [twitterJSON[@"teamId"] unsignedIntegerValue];
        
        if (twitterJSON[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:twitterJSON[@"team"]];
        }
    }
    
    return self;
}

@end
