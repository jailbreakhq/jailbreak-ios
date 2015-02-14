//
//  NSDictionary+JBAdditions.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 14/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "NSDictionary+JBAdditions.h"

@implementation NSDictionary (JBAdditions)

- (NSString *)jsonString
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:nil] encoding:NSUTF8StringEncoding];
}

@end
