//
//  JBTeam.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"

@implementation JBTeam

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
    }
    
    return self;
}

@end
