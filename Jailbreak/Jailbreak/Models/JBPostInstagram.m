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
    self = [super initWithCoder:aDecoder];
    
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
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:self.instagramMediaId forKey:@"instagramMediaId"];
    [aCoder encodeObject:self.instagramDescription forKey:@"instagramDescription"];
    [aCoder encodeObject:self.instagramURL forKey:@"instagramURL"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
    [aCoder encodeObject:self.authorUsername forKey:@"authorUsername"];
    [aCoder encodeObject:self.authorURL forKey:@"authorURL"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super initWithJSON:json];
    
    NSDictionary *instagramJSON = json[@"instagram"];
    
    if (self)
    {
        self.instagramMediaId = instagramJSON[@"instagramId"];
        self.instagramDescription = instagramJSON[@"description"];
        self.instagramURL = [NSURL URLWithString:instagramJSON[@"url"]];
        self.thumbnailURL = [NSURL URLWithString:instagramJSON[@"thumbnailUrl"]];
        self.authorUsername = instagramJSON[@"authorUrl"];
        self.authorURL = [NSURL URLWithString:instagramJSON[@"authorUrl"]];
        self.teamId = [instagramJSON[@"teamId"] unsignedIntegerValue];
        
        if (instagramJSON[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:instagramJSON[@"team"]];
        }
    }
    
    return self;
}

@end
