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
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, assign) NSUInteger teamID;
@property (nonatomic, strong) JBTeam *limitedTeam;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
