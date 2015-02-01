//
//  JBUser.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBUser.h"

@interface JBUser ()

- (Gender)getGenderFromString:(NSString *)string;

@end

@implementation JBUser

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.timeCreated = [aDecoder decodeIntegerForKey:@"timeCreated"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.gender = [aDecoder decodeIntegerForKey:@"gender"];
        self.timezone = [aDecoder decodeIntegerForKey:@"timezone"];
        self.locale = [aDecoder decodeObjectForKey:@"locale"];
        self.facebookLink = [aDecoder decodeObjectForKey:@"facebookLink"];
        self.apiTokensURL = [aDecoder decodeObjectForKey:@"apiTokensURL"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeInteger:self.timeCreated forKey:@"timeCreated"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeInteger:self.gender forKey:@"gender"];
    [aCoder encodeInteger:self.timezone forKey:@"timezone"];
    [aCoder encodeObject:self.locale forKey:@"locale"];
    [aCoder encodeObject:self.facebookLink forKey:@"facebookLink"];
    [aCoder encodeObject:self.apiTokensURL forKey:@"apiTokensURL"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"userId"] unsignedIntegerValue];
        self.timeCreated = [json[@"timeCreated"] integerValue];
        self.email = json[@"email"];
        self.firstName = json[@"firstName"];
        self.lastName = json[@"lastName"];
        self.gender = [self getGenderFromString:json[@"gender"]];
        self.timezone = [json[@"timezone"] integerValue];
        self.locale = json[@"locale"];
        self.facebookLink = json[@"facebookLink"];
        self.apiTokensURL = [NSURL URLWithString:json[@"apiTokensUrl"]];
    }
    
    return self;
}

#pragma mark - Private Methods

- (Gender)getGenderFromString:(NSString *)string
{
    NSDictionary *lookup = @{@"male": @0, @"female": @1, @"other": @2};
    
    return (Gender)lookup[string.lowercaseString];
}

@end
