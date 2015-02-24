//
//  JBPost.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"

@interface JBPost (Private)

- (JBPostType)getPostTypeFromString:(NSString *)string;

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
        self.postType = [aDecoder decodeIntegerForKey:@"socialNetwork"];
        self.postId = [aDecoder decodeObjectForKey:@"postId"];
        self.teamUniversity = [aDecoder decodeIntegerForKey:@"teamUniversity"];
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
    [aCoder encodeInteger:self.postType forKey:@"socialNetwork"];
    [aCoder encodeObject:self.postId forKey:@"postId"];
    [aCoder encodeInteger:self.teamUniversity forKey:@"teamUniversity"];
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
        self.postType = [self getPostTypeFromString:json[@"network"]];
        self.postId = json[@"postId"];
        self.teamUniversity = [JBTeam universityFromString:json[@"teamUniversity"]];
    }
    
    return self;
}

#pragma mark - Helper Methods

- (JBPostType)getPostTypeFromString:(NSString *)string
{
    NSDictionary *lookup = @{@"twitter": @0, @"instagram": @1, @"facebook": @2, @"vine": @3,
                             @"donate": @4, @"link": @5, @"checkin": @6};
    
    return (JBPostType)[lookup[string.lowercaseString] unsignedIntegerValue];
}

@end
