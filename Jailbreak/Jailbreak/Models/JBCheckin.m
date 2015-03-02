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
        self.locationString = [aDecoder decodeObjectForKey:@"locationString"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.createdTime = [aDecoder decodeObjectForKey:@"createdTime"];
        self.teamID = [aDecoder decodeIntegerForKey:@"teamID"];
        self.limitedTeam = [aDecoder decodeObjectForKey:@"limitedTeam"];
        self.distanceToX = [aDecoder decodeDoubleForKey:@"distanceToX"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.locationString forKey:@"locationString"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.createdTime forKey:@"createdTime"];
    [aCoder encodeInteger:self.teamID forKey:@"teamID"];
    [aCoder encodeObject:self.limitedTeam forKey:@"limitedTeam"];
    [aCoder encodeDouble:self.distanceToX forKey:@"distanceToX"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"id"] unsignedIntegerValue];
        self.locationString = json[@"location"];
        self.status = json[@"status"];
        self.location = [[CLLocation alloc] initWithLatitude:[json[@"lat"] doubleValue]
                                                   longitude:[json[@"lon"] doubleValue]];
        self.createdTime = [NSDate dateWithTimeIntervalSince1970:[json[@"time"] unsignedIntegerValue]];
        self.teamID = [json[@"teamId"] unsignedIntegerValue];
        self.distanceToX = [json[@"distanceToX"] floatValue] * 1000.0; // km -> m
        
        if (json[@"team"])
        {
            self.limitedTeam = [[JBTeam alloc] initWithJSON:json[@"team"]];
        }
    }
    
    return self;
}

@end
