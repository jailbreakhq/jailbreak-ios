//
//  JBPostVine.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostVine.h"

@implementation JBPostVine

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.vineDescription = [aDecoder decodeObjectForKey:@"vineDescription"];
        self.vineURL = [aDecoder decodeObjectForKey:@"vineURL"];
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
    
    [aCoder encodeObject:self.vineDescription forKey:@"vineDescription"];
    [aCoder encodeObject:self.vineURL forKey:@"vineURL"];
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
    
    NSDictionary *vineJSON = json[@"vine"];
    
    if (self)
    {
        self.vineDescription = vineJSON[@"description"];
        self.vineURL = [NSURL URLWithString:vineJSON[@"url"]];
        self.thumbnailURL = [NSURL URLWithString:vineJSON[@"thumbnailUrl"]];
        self.authorUsername = vineJSON[@"authorUrl"];
        self.authorURL = [NSURL URLWithString:vineJSON[@"authorUrl"]];
        self.teamId = [vineJSON[@"teamId"] unsignedIntegerValue];
        
        if (vineJSON[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:vineJSON[@"team"]];
        }
    }
    
    return self;
}

@end
