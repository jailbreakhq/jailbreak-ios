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
        self.team = [aDecoder decodeObjectForKey:@"team"];
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
    [aCoder encodeObject:self.team forKey:@"team"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super initWithJSON:json];
    
    if (self)
    {
        self.tweetId = [json[@"tweetId"] unsignedIntegerValue];
        self.tweetBodyPlain = json[@"tweet"];
        self.tweetBodyHTML = json[@"tweetHtml"];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[json[@"time"] doubleValue]];
        self.photoUrl = [NSURL URLWithString:json[@"photoUrl"]];
        self.inReplyToTwitterUsername = json[@"inReplyTo"];
        self.twitterUserId = [json[@"twitterUserId"] unsignedIntegerValue];
#warning possible typo by kevin?
        self.twitterUsername = json[@"twitterUserName"];
        self.twitterUserPhotoURL = [NSURL URLWithString:json[@"twitterUserPhoto"]];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        self.team = [[JBTeam alloc] initWithJSON:json];
    }
    
    return self;
}

@end