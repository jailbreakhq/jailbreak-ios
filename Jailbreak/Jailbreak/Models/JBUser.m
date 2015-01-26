//
//  JBUser.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBUser.h"

@implementation JBUser

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.timeCreated = [aDecoder decodeIntegerForKey:@"timeCreated"];
        self.userLevel = [aDecoder decodeIntegerForKey:@"userLevel"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.gender = [aDecoder decodeIntegerForKey:@"gender"];
        self.timezone = [aDecoder decodeIntegerForKey:@"timezone"];
        self.locale = [aDecoder decodeObjectForKey:@"locale"];
        self.facebookLink = [aDecoder decodeObjectForKey:@"facebookLink"];
        self.apiTokensURL = [aDecoder decodeObjectForKey:@"apiTokensURL"];
        self.href = [aDecoder decodeObjectForKey:@"href"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeInteger:self.timeCreated forKey:@"timeCreated"];
    [aCoder encodeInteger:self.userLevel forKey:@"userLevel"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeInteger:self.gender forKey:@"gender"];
    [aCoder encodeInteger:self.timezone forKey:@"timezone"];
    [aCoder encodeObject:self.locale forKey:@"locale"];
    [aCoder encodeObject:self.facebookLink forKey:@"facebookLink"];
    [aCoder encodeObject:self.apiTokensURL forKey:@"apiTokensURL"];
    [aCoder encodeObject:self.href forKey:@"href"];
}

#pragma mark - NSObject

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
