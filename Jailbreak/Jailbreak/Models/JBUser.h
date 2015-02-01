//
//  JBUser.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Gender)
{
    Male,
    Female,
    Other,
};

@interface JBUser : NSObject

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, assign) NSInteger timeCreated;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) NSInteger timezone; // +/- 12 UTC
@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *facebookLink;
@property (nonatomic, strong) NSURL *apiTokensURL;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
