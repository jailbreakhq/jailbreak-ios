//
//  JBPostBase.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostBase.h"

@implementation JBPostBase

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.postId = [aDecoder decodeIntegerForKey:@"postId"];
        self.postType = [aDecoder decodeIntegerForKey:@"postType"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.postId forKey:@"postId"];
    [aCoder encodeInteger:self.postType forKey:@"postType"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.postId = [json[@"id"] unsignedIntegerValue];
        self.postType = [JBPostBase getPostTypeFromString:json[@"type"]];
    }
    
    return self;
}

#pragma mark - Class Methods

+ (JBPostType)getPostTypeFromString:(NSString *)string
{
    NSDictionary *lookup = @{@"twitter": @1, @"instagram": @2, @"facebook": @3, @"vine": @4,
                             @"donate": @5, @"link": @6, @"checkin": @7};    
    
    return (JBPostType)[lookup[string.lowercaseString] unsignedIntegerValue];
}

@end
