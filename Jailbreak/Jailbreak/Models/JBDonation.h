//
//  JBDonation.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 29/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DonationType)
{
    Offline = 0,
    Online,
};

@interface JBDonation : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, assign) NSUInteger teamID;
@property (nonatomic, assign) NSUInteger amount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, assign) DonationType type;
@property (nonatomic, strong) NSString *email;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
