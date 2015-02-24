//
//  JBPostCheckin.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPostCheckin.h"

@implementation JBPostCheckin

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.checkin = [aDecoder decodeObjectForKey:@"checkin"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.checkin forKey:@"checkin"];
}

#pragma mark - Initialiser

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super initWithJSON:json];
    
    if (self)
    {
        self.checkin = [[JBCheckin alloc] initWithJSON:json];
    }
    
    return self;
}

@end
