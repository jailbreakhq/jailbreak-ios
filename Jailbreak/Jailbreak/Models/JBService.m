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
        self.startTime = [json[@"start_time"] unsignedIntegerValue];
        self.amountRaised = [json[@"amount_raised"] unsignedIntegerValue];
        self.winningTeamID = [json[@"winner_team_id"] unsignedIntegerValue];
        self.tfmLive = [json[@"tfm_live"] boolValue];
        self.finalLocationLatitude = [json[@"final_location_lat"] doubleValue];
        self.finalLocationLongitude = [json[@"final_location_lon"] doubleValue];
        self.teamsURL = [NSURL URLWithString:json[@"teams_url"]];
        self.authenticateURL = [NSURL URLWithString:json[@"athentication_url"]];
        self.usersURL = [NSURL URLWithString:json[@"users_url"]];
    }
    
    return self;
}

@end
