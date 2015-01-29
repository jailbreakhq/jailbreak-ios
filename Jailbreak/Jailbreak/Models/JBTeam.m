//
//  JBTeam.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"

@implementation JBTeam

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.number = [aDecoder decodeIntegerForKey:@"number"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.membersNames = [aDecoder decodeObjectForKey:@"membersNames"];
        self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
        self.tagLine = [aDecoder decodeObjectForKey:@"tagLine"];
        self.startLatitude = [aDecoder decodeDoubleForKey:@"startLatitude"];
        self.startLongitude = [aDecoder decodeDoubleForKey:@"startLongitude"];
        self.currentLatitude = [aDecoder decodeDoubleForKey:@"currentLatitude"];
        self.currentLongitude = [aDecoder decodeDoubleForKey:@"currentLongitude"];
        self.university = [aDecoder decodeIntegerForKey:@"university"];
        self.teamDescription = [aDecoder decodeObjectForKey:@"teamDescription"];
        self.amountRaisedOnline = [aDecoder decodeIntegerForKey:@"amountRaisedOnline"];
        self.amountRaisedOffline = [aDecoder decodeIntegerForKey:@"amountRaisedOffline"];
        self.distanceToX = [aDecoder decodeDoubleForKey:@"distanceToX"];
        self.countries = [aDecoder decodeIntegerForKey:@"countries"];
        self.transports = [aDecoder decodeIntegerForKey:@"transports"];
        self.donationsURL = [aDecoder decodeObjectForKey:@"donationsURL"];
        self.challenges = [aDecoder decodeObjectForKey:@"challenges"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeInteger:self.number forKey:@"number"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.membersNames forKey:@"membersNames"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
    [aCoder encodeObject:self.tagLine forKey:@"tagLine"];
    [aCoder encodeDouble:self.startLatitude forKey:@"startLatitude"];
    [aCoder encodeDouble:self.startLongitude forKey:@"startLongitude"];
    [aCoder encodeDouble:self.currentLatitude forKey:@"currentLatitude"];
    [aCoder encodeDouble:self.currentLongitude forKey:@"currentLongitude"];
    [aCoder encodeInteger:self.university forKey:@"university"];
    [aCoder encodeObject:self.teamDescription forKey:@"teamDescription"];
    [aCoder encodeInteger:self.amountRaisedOnline forKey:@"amountRaisedOnline"];
    [aCoder encodeInteger:self.amountRaisedOffline forKey:@"amountRaisedOffline"];
    [aCoder encodeDouble:self.distanceToX forKey:@"distanceToX"];
    [aCoder encodeInteger:self.countries forKey:@"countries"];
    [aCoder encodeInteger:self.transports forKey:@"transports"];
    [aCoder encodeObject:self.donationsURL forKey:@"donationsURL"];
    [aCoder encodeObject:self.challenges forKey:@"challenges"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"id"] unsignedIntegerValue];
        self.number = [json[@"team_number"] unsignedIntegerValue];
        self.name = json[@"team_name"];
        self.membersNames = json[@"names"];
        self.avatarURL = [NSURL URLWithString:json[@"avatar"]];
        self.tagLine = json[@"tag_line"];
        self.startLatitude = [json[@"start_lat"] doubleValue];
        self.startLongitude = [json[@"start_lon"] doubleValue];
        self.currentLatitude = [json[@"current_lat"] doubleValue];
        self.currentLongitude = [json[@"current_lon"] doubleValue];
        self.university = (University)[json[@"university"] unsignedIntegerValue];
        self.teamDescription = json[@"description"];
        self.amountRaisedOnline = [json[@"amount_raised_online"] unsignedIntegerValue];
        self.amountRaisedOffline = [json[@"amount_raised_offline"] unsignedIntegerValue];
        self.distanceToX = [json[@"distance_to_x"] doubleValue];
        self.countries = [json[@"countries"] unsignedIntegerValue];
        self.transports = [json[@"transports"] unsignedIntegerValue];
        self.donationsURL = [NSURL URLWithString:json[@"donations_url"]];
#warning Incomplete implementation
    }
    
    return self;
}

@end
