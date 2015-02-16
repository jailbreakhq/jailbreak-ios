//
//  JBAnnotation.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBAnnotation.h"

@implementation JBAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return self.customCoordinate;
}

- (NSString *)title
{
    return self.customTitle;
}

- (NSString *)subtitle
{
    return self.customSubtitle;
}

@end
