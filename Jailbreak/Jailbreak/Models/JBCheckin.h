//
//  JBCheckin.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JBCheckin : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDate *createdTime;
@property (nonatomic, assign) NSUInteger teamID;
@property (nonatomic, strong) JBTeam *limitedTeam;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
