//
//  JBService.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 30/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JBService : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger startTime;
@property (nonatomic, assign) NSUInteger amountRaised;
@property (nonatomic, assign) NSUInteger winningTeamID;
@property (nonatomic, assign, getter=isTFMLive) BOOL tfmLive;
@property (nonatomic, assign) CLLocationDegrees finalLocationLatitude;
@property (nonatomic, assign) CLLocationDegrees finalLocationLongitude;
@property (nonatomic, strong) NSURL *teamsURL;
@property (nonatomic, strong) NSURL *facebookTokensURL;
@property (nonatomic, strong) NSURL *authenticateURL;
@property (nonatomic, strong) NSURL *usersURL;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
