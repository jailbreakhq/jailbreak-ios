//
//  JBCheckin+Annotation.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 27/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <NSDate+DateTools.h>
#import "JBCheckin+Annotation.h"

@implementation JBCheckin (Annotation)

- (NSString *)title
{
    return self.locationString;
}

- (NSString *)subtitle
{
    return [self.createdTime timeAgoSinceNow];
}

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

@end
