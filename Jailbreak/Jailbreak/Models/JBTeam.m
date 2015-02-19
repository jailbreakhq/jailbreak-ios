//
//  JBTeam.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "UIColor+JBAdditions.h"

@interface JBTeam ()

- (University)getUniversityFromString:(NSString *)string;
- (NSString *)getUniversityString;
- (UIColor *)getUniversityColor;

@end

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
        self.slug = [aDecoder decodeObjectForKey:@"slug"];
        self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
        self.avatarLargeURL = [aDecoder decodeObjectForKey:@"avatarLargeURL"];
        self.tagLine = [aDecoder decodeObjectForKey:@"tagLine"];
        self.about = [aDecoder decodeObjectForKey:@"about"];
        self.currentLocation = [aDecoder decodeObjectForKey:@"currentLocation"];
        self.university = [aDecoder decodeIntegerForKey:@"university"];
        self.universityString = [aDecoder decodeObjectForKey:@"universityString"];
        self.amountRaisedOnline = [aDecoder decodeIntegerForKey:@"amountRaisedOnline"];
        self.amountRaisedOffline = [aDecoder decodeIntegerForKey:@"amountRaisedOffline"];
        self.distanceToX = [aDecoder decodeDoubleForKey:@"distanceToX"];
        self.distanceToX = [aDecoder decodeDoubleForKey:@"distanceTravelled"];
        self.countries = [aDecoder decodeIntegerForKey:@"countries"];
        self.transports = [aDecoder decodeIntegerForKey:@"transports"];
        self.donationsURL = [aDecoder decodeObjectForKey:@"donationsURL"];
        self.challenges = [aDecoder decodeObjectForKey:@"challenges"];
        self.featured = [aDecoder decodeBoolForKey:@"featured"];
        self.videoID = [aDecoder decodeObjectForKey:@"videoID"];
        self.universityColor = [aDecoder decodeObjectForKey:@"universityColor"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ID forKey:@"ID"];
    [aCoder encodeInteger:self.number forKey:@"number"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.membersNames forKey:@"membersNames"];
    [aCoder encodeObject:self.slug forKey:@"slug"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
    [aCoder encodeObject:self.avatarLargeURL forKey:@"avatarLargeURL"];
    [aCoder encodeObject:self.tagLine forKey:@"tagLine"];
    [aCoder encodeObject:self.about forKey:@"about"];
    [aCoder encodeObject:self.currentLocation forKey:@"currentLocation"];
    [aCoder encodeInteger:self.university forKey:@"university"];
    [aCoder encodeObject:self.universityString forKey:@"universityString"];
    [aCoder encodeInteger:self.amountRaisedOnline forKey:@"amountRaisedOnline"];
    [aCoder encodeInteger:self.amountRaisedOffline forKey:@"amountRaisedOffline"];
    [aCoder encodeDouble:self.distanceToX forKey:@"distanceToX"];
    [aCoder encodeDouble:self.distanceToX forKey:@"distanceTravelled"];
    [aCoder encodeInteger:self.countries forKey:@"countries"];
    [aCoder encodeInteger:self.transports forKey:@"transports"];
    [aCoder encodeObject:self.donationsURL forKey:@"donationsURL"];
    [aCoder encodeObject:self.challenges forKey:@"challenges"];
    [aCoder encodeBool:self.featured forKey:@"featured"];
    [aCoder encodeObject:self.videoID forKey:@"videoID"];
    [aCoder encodeObject:self.universityColor forKey:@"universityColor"];
}

#pragma mark - NSObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.ID = [json[@"id"] unsignedIntegerValue];
        self.number = [json[@"teamNumber"] unsignedIntegerValue];
        self.name = json[@"teamName"];
        self.membersNames = json[@"names"];
        self.slug = json[@"slug"];
        self.avatarURL = [NSURL URLWithString:json[@"avatar"]];
        self.avatarLargeURL = [NSURL URLWithString:json[@"avatarLarge"]];
        self.tagLine = json[@"tagLine"];
        self.about = json[@"description"];
        CLLocationDegrees lat = [json[@"currentLat"] doubleValue];
        CLLocationDegrees lon = [json[@"currentLon"] doubleValue];
        self.currentLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        self.university = [self getUniversityFromString:json[@"university"]];
        self.universityString = [self getUniversityString];
        self.amountRaisedOnline = [json[@"amountRaisedOnline"] unsignedIntegerValue];
        self.amountRaisedOffline = [json[@"amountRaisedOffline"] unsignedIntegerValue];
        self.distanceToX = [json[@"distanceToX"] doubleValue];
        self.countries = [json[@"countries"] unsignedIntegerValue];
        self.transports = [json[@"transports"] unsignedIntegerValue];
        self.donationsURL = [NSURL URLWithString:json[@"donationsUrl"]];
        self.featured = [json[@"featured"] boolValue];
        self.videoID = json[@"video"];
        self.universityColor = [self getUniversityColor];
        
        NSMutableArray *tempChallenges = [NSMutableArray new];
        for (NSDictionary *challenge in json[@"challenges"])
        {
            [tempChallenges addObject:[[JBChallenge alloc] initWithJSON:challenge]];
        }
        self.challenges = [tempChallenges copy];

        
        if (!self.videoID || ![self.videoID isEqual:[NSNull null]])
        {
            self.videoID = [[self.videoID componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] objectAtIndex:1];
            self.videoID = [[self.videoID componentsSeparatedByString:@"/"] lastObject];
            self.videoID = [self.videoID stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            self.videoID = [self.videoID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }
    }
    
    return self;
}

#pragma mark - Private Methods

- (University)getUniversityFromString:(NSString *)string
{
    NSDictionary *lookup = @{@"tcd": @0, @"ucd": @1, @"ucc": @2, @"nuig": @3,
                             @"nuim": @4, @"cit": @5, @"nci": @6, @"gmit": @7,
                             @"itt": @8, @"itc": @9};
    
    return (University)[lookup[string.lowercaseString] unsignedIntegerValue];
}

- (UIColor *)getUniversityColor
{
    switch (self.university)
    {
        case TCD:
            return [UIColor colorWithHexString:@"#85387C"];
        case UCD:
            return [UIColor colorWithHexString:@"#388085"];
        case UCC:
            return [UIColor colorWithHexString:@"#C94242"];
        case NUIG:
            return [UIColor colorWithHexString:@"#1EC971"];
        default:
            return [UIColor colorWithHexString:@"#4672A6"];
    }
}

- (NSString *)getUniversityString
{
    NSDictionary *lookup = @{@0: @"TCD", @1: @"UCD", @2: @"UCC", @3: @"NUIG",
                             @4: @"NUIM", @5: @"CIT", @6: @"NCI", @7: @"GMIT",
                             @8: @"ITT", @9: @"ITC"};
    
    return lookup[@(self.university)];
}

@end
