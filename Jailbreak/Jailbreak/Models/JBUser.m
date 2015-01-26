//
//  JBUser.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBUser.h"

@implementation JBUser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"id"] unsignedIntegerValue];
        self.timeCreated = [json[@"time_created"] integerValue];
        self.userLevel = (UserLevel)[json[@"user_level"] unsignedIntegerValue];
        self.email = json[@"email"];
        self.firstName = json[@"first_name"];
        self.lastName = json[@"last_name"];
        self.gender = (Gender)[json[@"gender"] unsignedIntegerValue];
        self.timezone = [json[@"timezone"] integerValue];
        self.locale = json[@"locale"];
        self.facebookLink = json[@"facebook_link"];
        self.apiTokensURL = [NSURL URLWithString:json[@"api_tokens_url"]];
        self.href = json[@"href"];
    }
    
    return self;
}

@end
