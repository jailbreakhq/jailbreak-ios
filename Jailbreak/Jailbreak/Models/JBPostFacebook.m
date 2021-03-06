//
//  JBPostFacebook.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostFacebook.h"

@implementation JBPostFacebook

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.facebookPostId = [aDecoder decodeObjectForKey:@"facebookPostId"];
        self.facebookPostURL = [aDecoder decodeObjectForKey:@"facebookPostURL"];
        self.facebookPostBody = [aDecoder decodeObjectForKey:@"facebookPostBody"];
        self.linkURL = [aDecoder decodeObjectForKey:@"linkURL"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
        self.facebookPageName = [aDecoder decodeObjectForKey:@"facebookPageName"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
        self.authorPhotoURL = [aDecoder decodeObjectForKey:@"authorPhotoURL"];
        self.photoURL = [aDecoder decodeObjectForKey:@"photoURL"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.facebookPostId forKey:@"facebookPostId"];
    [aCoder encodeObject:self.facebookPostURL forKey:@"facebookPostURL"];
    [aCoder encodeObject:self.facebookPostBody forKey:@"facebookPostBody"];
    [aCoder encodeObject:self.linkURL forKey:@"linkURL"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
    [aCoder encodeObject:self.facebookPageName forKey:@"facebookPageName"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
    [aCoder encodeObject:self.authorPhotoURL forKey:@"authorPhotoURL"];
    [aCoder encodeObject:self.photoURL forKey:@"photoURL"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.facebookPostId = json[@"facebookId"];
        self.facebookPostURL = [NSURL URLWithString:json[@"url"]];
        self.facebookPostBody = json[@"message"];
        self.linkURL = [NSURL URLWithString:json[@"linkUrl"]];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[json[@"time"] doubleValue]];
        self.facebookPageName = json[@"pageName"];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        self.authorPhotoURL = [NSURL URLWithString:json[@"authorPhotoUrl"]];
        self.photoURL = [NSURL URLWithString:json[@"photoUrl"]];
        
        if (json[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:json[@"team"]];
        }
    }
    
    return self;
}

@end
