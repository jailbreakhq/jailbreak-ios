//
//  JBPostDonate.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostDonate.h"

@implementation JBPostDonate

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.donateDescription = [aDecoder decodeObjectForKey:@"donateDescription"];
        self.buttonText = [aDecoder decodeObjectForKey:@"buttonText"];
        self.teamId = [aDecoder decodeIntegerForKey:@"teamId"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.donateDescription forKey:@"donateDescription"];
    [aCoder encodeObject:self.buttonText forKey:@"buttonText"];
    [aCoder encodeInteger:self.teamId forKey:@"teamId"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.donateDescription = json[@"description"];
        self.buttonText = json[@"linkText"];
        self.teamId = [json[@"teamId"] unsignedIntegerValue];
    
        if (json[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:json[@"team"]];
        }
    }
    
    return self;
}

@end
