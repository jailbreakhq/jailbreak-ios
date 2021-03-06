//
//  JBPost.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"

@implementation JBPost

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.postId = [aDecoder decodeIntegerForKey:@"postId"];
        self.postType = [aDecoder decodeIntegerForKey:@"postType"];
        self.containsThumbnail = [aDecoder decodeBoolForKey:@"containsThumbnail"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
        self.checkin = [aDecoder decodeObjectForKey:@"checkin"];
        self.link = [aDecoder decodeObjectForKey:@"link"];
        self.vine = [aDecoder decodeObjectForKey:@"vine"];
        self.donate = [aDecoder decodeObjectForKey:@"donate"];
        self.twitter = [aDecoder decodeObjectForKey:@"twitter"];
        self.facebook = [aDecoder decodeObjectForKey:@"facebook"];
        self.instagram = [aDecoder decodeObjectForKey:@"instagram"];
        self.youtube = [aDecoder decodeObjectForKey:@"youtube"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.postId forKey:@"postId"];
    [aCoder encodeInteger:self.postType forKey:@"postType"];
    [aCoder encodeBool:self.containsThumbnail forKey:@"containsThumbnail"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
    [aCoder encodeObject:self.checkin forKey:@"checkin"];
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeObject:self.vine forKey:@"vine"];
    [aCoder encodeObject:self.donate forKey:@"donate"];
    [aCoder encodeObject:self.twitter forKey:@"twitter"];
    [aCoder encodeObject:self.facebook forKey:@"facebook"];
    [aCoder encodeObject:self.instagram forKey:@"instagram"];
    [aCoder encodeObject:self.youtube forKey:@"youtube"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.postId = [json[@"id"] unsignedIntegerValue];
        self.postType = [JBPost getPostTypeFromString:json[@"type"]];
        self.containsThumbnail = NO;

        switch (self.postType)
        {
            case JBPostTypeCheckin:
                self.checkin = [[JBCheckin alloc] initWithJSON:json[@"checkin"]];
                self.limitedTeam = self.checkin.limitedTeam ?: nil;
                self.createdTime = self.checkin.createdTime;
                break;
            case JBPostTypeDonate:
                self.donate = [[JBPostDonate alloc] initWithJSON:json[@"donate"]];
                self.limitedTeam = self.donate.limitedTeam ?: nil;
                break;
            case JBPostTypeFacebook:
                self.facebook = [[JBPostFacebook alloc] initWithJSON:json[@"facebook"]];
                self.limitedTeam = self.facebook.limitedTeam ?: nil;
                self.createdTime = self.facebook.createdTime;
                self.containsThumbnail = self.facebook.photoURL != nil;
                break;
            case JBPostTypeInstagram:
                self.instagram = [[JBPostInstagram alloc] initWithJSON:json[@"instagram"]];
                self.containsThumbnail = YES;
                self.limitedTeam = self.instagram.limitedTeam ?: nil;
                self.createdTime = self.instagram.createdTime;
                break;
            case JBPostTypeLink:
                self.link = [[JBPostLink alloc] initWithJSON:json[@"link"]];
                self.containsThumbnail = self.link.photoURL != nil;
                break;
            case JBPostTypeTwitter:
                self.twitter = [[JBPostTwitter alloc] initWithJSON:json[@"twitter"]];
                self.containsThumbnail = self.twitter.photoURL != nil;
                self.limitedTeam = self.twitter.limitedTeam ?: nil;
                self.createdTime = self.twitter.createdTime;
                break;
            case JBPostTypeVine:
                self.vine = [[JBPostVine alloc] initWithJSON:json[@"vine"]];
                self.containsThumbnail = YES;
                self.limitedTeam = self.vine.limitedTeam ?: nil;
                self.createdTime = self.vine.createdTime;
                break;
            case JBPostTypeYouTube:
                self.youtube = [[JBPostYouTube alloc] initWithJSON:json[@"youtube"]];
                self.containsThumbnail = YES;
                self.limitedTeam = self.youtube.limitedTeam ?: nil;
                self.createdTime = self.youtube.createdTime;
                break;
            case JBPostTypeUndefined:
                break;
        }
    }
    
    return self;
}

#pragma mark - Class Methods

+ (JBPostType)getPostTypeFromString:(NSString *)string
{
    NSDictionary *lookup = @{@"twitter": @1, @"instagram": @2, @"facebook": @3, @"vine": @4,
                             @"donate": @5, @"link": @6, @"checkin": @7, @"youtube": @8};
    
    return (JBPostType)[lookup[string.lowercaseString] unsignedIntegerValue];
}

@end
