//
//  JBTeam.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

@class JBCheckin;

#import "JBCheckin.h"
#import "JBDonation.h"
#import "JBChallenge.h"
#import <UIKit/UIKit.h>
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
    ITT,
};

@interface JBTeam : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *membersNames;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSURL *avatarURL; // 300x300
@property (nonatomic, strong) NSURL *avatarLargeURL; // 1024x1024
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, assign) University university;
@property (nonatomic, strong) NSString *universityString;
@property (nonatomic, assign) NSUInteger amountRaisedOnline;
@property (nonatomic, assign) NSUInteger amountRaisedOffline;
@property (nonatomic, assign) NSUInteger countries;
@property (nonatomic, assign) NSUInteger transports;
@property (nonatomic, strong) NSURL *donationsURL;
@property (nonatomic, strong) NSArray *challenges; // of type JBChallenge
@property (nonatomic, assign, getter=isFeatured) BOOL featured;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSURL *videoThumbnailURL;
@property (nonatomic, strong) UIColor *universityColor;
@property (nonatomic, assign) NSUInteger position;
@property (nonatomic, strong) JBCheckin *lastCheckin;
@property (nonatomic, assign) NSInteger numberOfDonations;
@property (nonatomic, strong) NSMutableArray *checkins;
@property (nonatomic, strong) NSMutableArray *donations;

- (instancetype)initWithJSON:(NSDictionary *)json;

+ (UIColor *)colorForUniversity:(University)university;
+ (University)universityFromString:(NSString *)string;

@end
