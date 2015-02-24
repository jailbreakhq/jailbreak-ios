//
//  JBPostFacebook.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "JBPostBase.h"

@interface JBPostFacebook : JBPostBase

@property (nonatomic, assign) NSUInteger facebookPostId;
@property (nonatomic,strong) NSString *facebookPostBody;
@property (nonatomic, strong) NSURL *linkURL; // optional
@property (nonatomic, strong) NSDate *createdTime;
@property (nonatomic, assign) NSUInteger teamId; // optional
@property (nonatomic, strong) JBTeam *team; // optional

@end
