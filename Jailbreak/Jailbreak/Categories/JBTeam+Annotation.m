//
//  JBTeam+Annotation.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 27/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam+Annotation.h"

@implementation JBTeam (Annotation)

- (NSString *)title
{
    return self.membersNames;
}

- (NSString *)subtitle
{
    return self.lastCheckin.locationString;
}

- (CLLocationCoordinate2D)coordinate
{
    return self.lastCheckin.location.coordinate;
}

@end
