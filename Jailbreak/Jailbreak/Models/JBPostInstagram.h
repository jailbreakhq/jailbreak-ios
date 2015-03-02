//
//  JBPostInstagram.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"

@interface JBPostInstagram : NSObject <NSCoding>

@property (nonatomic, strong) NSString *instagramMediaId;
@property (nonatomic, strong) NSString *instagramDescription;
@property (nonatomic, strong) NSURL *instagramURL;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSString *authorUsername;
@property (nonatomic, strong) NSURL *authorURL;
@property (nonatomic, assign) NSUInteger teamId;
@property (nonatomic, strong) JBTeam *limitedTeam;
@property (nonatomic, strong) NSURL *authorPhotoURL;
@property (nonatomic, strong) NSDate *createdTime;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
