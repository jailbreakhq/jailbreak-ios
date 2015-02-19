//
//  JBChallenge.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 29/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ChallengeType)
{
    Blindfold = 0,
    PaperBoats,
    Education,
    Altruism,
};

@interface JBChallenge : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, assign) NSUInteger teamID;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) ChallengeType type;
@property (nonatomic, assign) NSUInteger completedTime;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
