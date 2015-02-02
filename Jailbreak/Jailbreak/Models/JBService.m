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
        self.startLocationLatitude = [aDecoder decodeDoubleForKey:@"startLocationLatitude"];
        self.startLocationLongitude = [aDecoder decodeDoubleForKey:@"startLocationLongitude"];
        self.finalLocationLatitude = [aDecoder decodeDoubleForKey:@"finalLocationLatitude"];
        self.finalLocationLongitude = [aDecoder decodeDoubleForKey:@"finalLocationLongitude"];
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
    [aCoder encodeDouble:self.startLocationLatitude forKey:@"startLocationLatitude"];
    [aCoder encodeDouble:self.startLocationLongitude forKey:@"startLocationLongitude"];
    [aCoder encodeDouble:self.finalLocationLatitude forKey:@"finalLocationLatitude"];
    [aCoder encodeDouble:self.finalLocationLongitude forKey:@"finalLocationLongitude"];
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
        self.startLocationLatitude = [json[@"startLocationLat"] doubleValue];
        self.startLocationLongitude = [json[@"startLocationLon"] doubleValue];
        self.finalLocationLatitude = [json[@"finalLocationLat"] doubleValue];
        self.finalLocationLongitude = [json[@"finalLocationLon"] doubleValue];
        self.teamsURL = [NSURL URLWithString:json[@"teamsUrl"]];
        self.facebookTokensURL = [NSURL URLWithString:json[@"facebookTokensUrl"]];
        self.authenticateURL = [NSURL URLWithString:json[@"authenticateUrl"]];
        self.usersURL = [NSURL URLWithString:json[@"usersUrl"]];
    }
    
    return self;
}

@end
