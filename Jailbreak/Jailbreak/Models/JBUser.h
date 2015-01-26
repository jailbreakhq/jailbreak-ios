//
//  JBUser.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UserLevel)
{
    SuperAdmin,
    Admin,
    Tracker,
    Normal,
};

typedef NS_ENUM(NSUInteger, Gender)
{
    Male,
    Female,
    Other,
};

@interface JBUser : NSObject

@property (nonatomic, assign) NSUInteger ID;
#warning Vague
@property (nonatomic, assign) NSInteger timeCreated;
@property (nonatomic, assign) UserLevel userLevel;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) Gender gender;
#warning Vague
@property (nonatomic, assign) NSInteger timezone;
@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *facebookLink;
@property (nonatomic, strong) NSURL *apiTokensURL;
@property (nonatomic, strong) NSString *href;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end