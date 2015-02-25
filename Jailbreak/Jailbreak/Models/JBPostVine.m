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
    self = [super init];
    
    if (self)
    {
        self.vineDescription = [aDecoder decodeObjectForKey:@"vineDescription"];
        self.vineURL = [aDecoder decodeObjectForKey:@"vineURL"];
        self.thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
        self.remoteVideoURL = [aDecoder decodeObjectForKey:@"remoteVideoURL"];
//        self.localVideoURL = [aDecoder decodeObjectForKey:@"localVideoURL"];
        self.authorUsername = [aDecoder decodeObjectForKey:@"authorUsername"];
        self.authorURL = [aDecoder decodeObjectForKey:@"authorURL"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.vineDescription forKey:@"vineDescription"];
    [aCoder encodeObject:self.vineURL forKey:@"vineURL"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
    [aCoder encodeObject:self.remoteVideoURL forKey:@"remoteVideoURL"];
//    [aCoder encodeObject:self.localVideoURL forKey:@"localVideoURL"];
    [aCoder encodeObject:self.authorUsername forKey:@"authorUsername"];
    [aCoder encodeObject:self.authorURL forKey:@"authorURL"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.vineDescription = json[@"description"];
        self.vineURL = [NSURL URLWithString:json[@"url"]];
        self.thumbnailURL = [NSURL URLWithString:json[@"thumbnailUrl"]];
        self.authorUsername = json[@"authorName"];
        self.authorURL = [NSURL URLWithString:json[@"authorUrl"]];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
        
        if (json[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:json[@"team"]];
        }
        
        NSString *urlString = json[@"thumbnailUrl"];
        NSRange range = [urlString rangeOfString:@".jpg"];
        
        if (range.location != NSNotFound)
        {
            range.length = range.location;
            range.location = 0;
            urlString = [urlString substringWithRange:range];
            self.remoteVideoURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}

@end
