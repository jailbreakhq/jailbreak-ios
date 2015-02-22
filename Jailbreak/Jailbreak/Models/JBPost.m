//
//  JBPost.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"

@interface JBPost (Private)

- (JBPostSocialNetwork)getPostTypeFromString:(NSString *)string;

@end

@implementation JBPost

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.teamName = [aDecoder decodeObjectForKey:@"teamName"];
        self.teamMembersNames = [aDecoder decodeObjectForKey:@"teamMembersNames"];
        self.teamAvatarURL = [aDecoder decodeObjectForKey:@"teamAvatarURL"];
        self.body = [aDecoder decodeObjectForKey:@"body"];
        self.mediaURL = [aDecoder decodeObjectForKey:@"mediaURL"];
        self.timeCreated = [aDecoder decodeObjectForKey:@"timeCreated"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.socialNetwork = [aDecoder decodeIntegerForKey:@"socialNetwork"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.teamName forKey:@"teamName"];
    [aCoder encodeObject:self.teamMembersNames forKey:@"teamMembersNames"];
    [aCoder encodeObject:self.teamAvatarURL forKey:@"teamAvatarURL"];
    [aCoder encodeObject:self.body forKey:@"body"];
    [aCoder encodeObject:self.mediaURL forKey:@"mediaURL"];
    [aCoder encodeObject:self.timeCreated forKey:@"timeCreated"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeInteger:self.socialNetwork forKey:@"socialNetwork"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        self.teamName = json[@"teamName"];
        self.teamMembersNames = json[@"teamMembersNames"];
        self.teamAvatarURL = [NSURL URLWithString:json[@"teamAvatar"]];
        self.body = json[@"body"];
        self.mediaURL = [NSURL URLWithString:json[@"media"]];
        self.timeCreated = [NSDate date];
        self.username = json[@"username"];
        self.socialNetwork = [self getPostTypeFromString:json[@"network"]];
    }
    
    return self;
}

#pragma mark - Helper Methods

- (JBPostSocialNetwork)getPostTypeFromString:(NSString *)string
{
    NSDictionary *lookup = @{@"twitter": @0, @"instagram": @1, @"facebook": @2, @"vine": @3};
    
    return (JBPostSocialNetwork)[lookup[string.lowercaseString] unsignedIntegerValue];
}

@end
