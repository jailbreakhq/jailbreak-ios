//
//  JBDonation.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 29/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBDonation.h"

@interface JBDonation ()

- (DonationType)getDonationTypeFromString:(NSString *)string;

@end

@implementation JBDonation

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.teamID = [aDecoder decodeIntegerForKey:@"teamID"];
        self.amount = [aDecoder decodeIntegerForKey:@"amount"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.time = [aDecoder decodeIntegerForKey:@"time"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeInteger:self.teamID forKey:@"teamID"];
    [aCoder encodeInteger:self.amount forKey:@"amount"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.time forKey:@"time"];
    [aCoder encodeInteger:self.type forKey:@"type"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"id"] unsignedIntegerValue];
        self.teamID = [json[@"teamId"] unsignedIntegerValue];
        self.amount = [json[@"amount"] unsignedIntegerValue];
        self.name = json[@"name"];
        self.time = [json[@"time"] unsignedIntegerValue];
        self.type = [self getDonationTypeFromString:json[@"type"]];
    }
    
    return self;
}

#pragma mark - Private Methods

- (DonationType)getDonationTypeFromString:(NSString *)string
{
    NSDictionary *lookup = @{@"offline": @0, @"online": @1};
    
    return (DonationType)lookup[string.lowercaseString];
}

@end
