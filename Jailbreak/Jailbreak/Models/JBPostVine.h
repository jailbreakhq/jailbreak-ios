//
//  JBPostVine.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"

@interface JBPostVine : NSObject <NSCoding>

@property (nonatomic, strong) NSString *vineDescription;
@property (nonatomic, strong) NSURL *vineURL;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSURL *remoteVideoURL;
@property (nonatomic, strong) NSURL *localVideoURL;
@property (nonatomic, strong) NSString *authorUsername;
@property (nonatomic, strong) NSURL *authorURL;
@property (nonatomic, assign) NSUInteger teamId;
@property (nonatomic, strong) JBTeam *limitedTeam;
@property (nonatomic, strong) NSURL *authorPhotoURL;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
