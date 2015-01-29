//
//  JBTeam.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBChallenge.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, University)
{
    TCD = 0,
    UCD,
    UCC,
    NUIG,
    NUIM,
    CIT,
    NCI,
    GMIT,
    ITT,
    ITC
};

@interface JBTeam : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *membersNames;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic, assign) CLLocationDegrees startLatitude;
@property (nonatomic, assign) CLLocationDegrees startLongitude;
@property (nonatomic, assign) CLLocationDegrees currentLatitude;
@property (nonatomic, assign) CLLocationDegrees currentLongitude;
@property (nonatomic, assign) University university;
@property (nonatomic, strong) NSString *teamDescription;
#warning These should be doubles right Kevin?
@property (nonatomic, assign) NSUInteger amountRaisedOnline;
@property (nonatomic, assign) NSUInteger amountRaisedOffline;
@property (nonatomic, assign) CLLocationDistance distanceToX;
@property (nonatomic, assign) NSUInteger countries;
@property (nonatomic, assign) NSUInteger transports;
@property (nonatomic, strong) NSURL *donationsURL;
@property (nonatomic, strong) NSArray *challenges; // of type JBChallenge


- (instancetype)initWithJSON:(NSDictionary *)json;

@end
