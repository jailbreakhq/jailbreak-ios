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
    NSDictionary *lookup = @{@"twitter": @0, @"instagram": @1, @"facebook": @2, @"vine": @3,
                             @"donate": @4, @"link": @5, @"checkin": @6};
    
    return (JBPostType)[lookup[string.lowercaseString] unsignedIntegerValue];
}

@end
