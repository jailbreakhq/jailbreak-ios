//
//  JBService.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 30/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBService.h"

@implementation JBService

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.startTime = [aDecoder decodeIntegerForKey:@"startTime"];
        self.amountRaised = [aDecoder decodeIntegerForKey:@"amountRaised"];
        self.winningTeamID = [aDecoder decodeIntegerForKey:@"winningTeamID"];
        self.tfmLive = [aDecoder decodeBoolForKey:@"tfmLive"];
        self.startLocation = [aDecoder decodeObjectForKey:@"startLocation"];
        self.finalLocation = [aDecoder decodeObjectForKey:@"finalLocation"];
        self.teamsURL = [aDecoder decodeObjectForKey:@"teamsURL"];
        self.facebookTokensURL = [aDecoder decodeObjectForKey:@"facebookTokensURL"];
        self.authenticateURL = [aDecoder decodeObjectForKey:@"authenticateURL"];
        self.usersURL = [aDecoder decodeObjectForKey:@"usersURL"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.startTime forKey:@"startTime"];
    [aCoder encodeInteger:self.amountRaised forKey:@"amountRaised"];
    [aCoder encodeInteger:self.winningTeamID forKey:@"winningTeamID"];
    [aCoder encodeBool:self.tfmLive forKey:@"tfmLive"];
    [aCoder encodeObject:self.startLocation forKey:@"startLocation"];
    [aCoder encodeObject:self.finalLocation forKey:@"finalLocation"];
    [aCoder encodeObject:self.teamsURL forKey:@"teamsURL"];
    [aCoder encodeObject:self.facebookTokensURL forKey:@"facebookTokensURL"];
    [aCoder encodeObject:self.authenticateURL forKey:@"authenticateURL"];
    [aCoder encodeObject:self.usersURL forKey:@"usersURL"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.startTime = [json[@"startTime"] unsignedIntegerValue];
        self.amountRaised = [json[@"amountRaised"] unsignedIntegerValue];
        self.winningTeamID = [json[@"winnerTeamId"] unsignedIntegerValue];
        self.tfmLive = [json[@"tfm_live"] boolValue];
        CLLocationDegrees lat, lon;
        lat = [json[@"startLocationLat"] doubleValue];
        lon = [json[@"startLocationLon"] doubleValue];
        self.startLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        lat = [json[@"finalLocationLat"] doubleValue];
        lon = [json[@"finalLocationLon"] doubleValue];
        self.finalLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        self.teamsURL = [NSURL URLWithString:json[@"teamsUrl"]];
        self.facebookTokensURL = [NSURL URLWithString:json[@"facebookTokensUrl"]];
        self.authenticateURL = [NSURL URLWithString:json[@"authenticateUrl"]];
        self.usersURL = [NSURL URLWithString:json[@"usersUrl"]];
    }
    
    return self;
}

@end
