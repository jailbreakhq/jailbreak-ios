//
//  JBCheckin.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBCheckin.h"

@implementation JBCheckin

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        self.time = [aDecoder decodeIntegerForKey:@"time"];
        self.teamID = [aDecoder decodeIntegerForKey:@"teamID"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
    [aCoder encodeInteger:self.time forKey:@"time"];
    [aCoder encodeInteger:self.teamID forKey:@"teamID"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"id"] unsignedIntegerValue];
        self.location = json[@"location"];
        self.status = json[@"status"];
        self.latitude = [json[@"lat"] doubleValue];
        self.longitude = [json[@"lon"] doubleValue];
        self.time = [json[@"time"] unsignedIntegerValue];
        self.teamID = [json[@"teamId"] unsignedIntegerValue];
    }
    
    return self;
}

@end
