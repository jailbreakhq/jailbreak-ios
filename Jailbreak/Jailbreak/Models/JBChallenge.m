//
//  JBChallenge.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 29/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBChallenge.h"

@implementation JBChallenge

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.teamID = [aDecoder decodeIntegerForKey:@"teamID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.completed = [aDecoder decodeBoolForKey:@"completed"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.completedTime = [aDecoder decodeIntegerForKey:@"completedTime"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeInteger:self.teamID forKey:@"teamID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeBool:self.completed forKey:@"completed"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeInteger:self.completedTime forKey:@"completedTime"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"id"] unsignedIntegerValue];
        self.teamID = [json[@"team_id"] unsignedIntegerValue];
        self.name = json[@"name"];
        self.completed = [json[@"completed"] boolValue];
        self.type = (ChallengeType)[json[@"type"] unsignedIntegerValue];
        self.completedTime = [json[@"completed_time"] unsignedIntegerValue];
    }
    
    return self;
}

@end
