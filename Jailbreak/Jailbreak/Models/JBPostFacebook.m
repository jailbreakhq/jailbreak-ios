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
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.facebookPostId = [aDecoder decodeIntegerForKey:@"facebookPostId"];
        self.facebookPostBody = [aDecoder decodeObjectForKey:@"facebookPostBody"];
        self.linkURL = [aDecoder decodeObjectForKey:@"linkURL"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.team = [aDecoder decodeObjectForKey:@"team"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInteger:self.facebookPostId forKey:@"facebookPostId"];
    [aCoder encodeObject:self.facebookPostBody forKey:@"facebookPostBody"];
    [aCoder encodeObject:self.linkURL forKey:@"linkURL"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.team forKey:@"team"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super initWithJSON:json];
    
    if (self)
    {
        self.facebookPostId = [json[@"facebookId"] unsignedIntegerValue];
        self.facebookPostBody = json[@"message"];
#warning kevin did you forget to camel case this?
        self.linkURL = [NSURL URLWithString:json[@"link_url"]];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[json[@"time"] doubleValue]];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        self.team = [[JBTeam alloc] initWithJSON:json];
    }
    
    return self;
}

@end
