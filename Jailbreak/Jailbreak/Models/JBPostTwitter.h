//
//  JBPostTwitter.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "JBPostBase.h"

@interface JBPostTwitter : JBPostBase

@property (nonatomic, assign) NSUInteger tweetId;
@property (nonatomic, strong) NSString *tweetBodyPlain;
@property (nonatomic, strong) NSString *tweetBodyHTML;
@property (nonatomic, strong) NSDate *createdTime;
@property (nonatomic, strong) NSURL *photoUrl; // optional
@property (nonatomic, strong) NSString *inReplyToTwitterUsername;
@property (nonatomic, assign) NSUInteger twitterUserId;
@property (nonatomic, strong) NSString *twitterUsername;
@property (nonatomic, strong) NSURL *twitterUserPhotoURL;
@property (nonatomic, assign) NSUInteger teamId; // optional
@property (nonatomic, strong) JBTeam *team; // optional

@end
