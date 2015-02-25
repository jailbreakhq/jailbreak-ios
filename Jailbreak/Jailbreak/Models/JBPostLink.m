//
//  JBPostLink.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostLink.h"

@implementation JBPostLink

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.linkText = [aDecoder decodeObjectForKey:@"linkText"];
        self.linkDescription = [aDecoder decodeObjectForKey:@"linkDescription"];
        self.photoURL = [aDecoder decodeObjectForKey:@"photoURL"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.linkText forKey:@"linkText"];
    [aCoder encodeObject:self.linkDescription forKey:@"linkDescription"];
    [aCoder encodeObject:self.photoURL forKey:@"photoURL"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.url = [NSURL URLWithString:json[@"url"]];
        self.linkText = json[@"linkText"];
        self.linkDescription = json[@"description"];
        self.photoURL = [NSURL URLWithString:json[@"photoUrl"]];
    }
    
    return self;
}

@end
