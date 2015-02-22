//
//  JBPost.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JBPostSocialNetwork)
{
    JBPostSocialNetworkTwitter = 0,
    JBPostSocialNetworkInstagram,
    JBPostSocialNetworkFacebook,
    JBPostSocialNetworkVine,
};

@interface JBPost : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger teamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamMembersNames;
@property (nonatomic, strong) NSURL *teamAvatarURL;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) NSDate *timeCreated;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) JBPostSocialNetwork socialNetwork;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
