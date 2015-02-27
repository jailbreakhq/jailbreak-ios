//
//  JBPostInstagram.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostInstagram.h"

@implementation JBPostInstagram

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.instagramMediaId = [aDecoder decodeObjectForKey:@"instagramMediaId"];
        self.instagramDescription = [aDecoder decodeObjectForKey:@"instagramDescription"];
        self.instagramURL = [aDecoder decodeObjectForKey:@"instagramURL"];
        self.thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
        self.authorUsername = [aDecoder decodeObjectForKey:@"authorUsername"];
        self.authorURL = [aDecoder decodeObjectForKey:@"authorURL"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
        self.photoURL = [aDecoder decodeObjectForKey:@"photoURL"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.instagramMediaId forKey:@"instagramMediaId"];
    [aCoder encodeObject:self.instagramDescription forKey:@"instagramDescription"];
    [aCoder encodeObject:self.instagramURL forKey:@"instagramURL"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
    [aCoder encodeObject:self.authorUsername forKey:@"authorUsername"];
    [aCoder encodeObject:self.authorURL forKey:@"authorURL"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
    [aCoder encodeObject:self.photoURL forKey:@"photoURL"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.instagramMediaId = json[@"instagramId"];
        self.instagramDescription = json[@"description"];
        self.instagramURL = [NSURL URLWithString:json[@"url"]];
        self.thumbnailURL = [NSURL URLWithString:json[@"thumbnailUrl"]];
        self.authorUsername = json[@"authorName"];
        self.authorURL = [NSURL URLWithString:json[@"authorUrl"]];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        self.photoURL = [NSURL URLWithString:json[@"photoURL"]];
        
        if (json[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:json[@"team"]];
        }
    }
    
    return self;
}

@end
