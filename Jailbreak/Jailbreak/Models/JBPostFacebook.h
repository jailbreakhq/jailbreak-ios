//
//  JBPostFacebook.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"

@interface JBPostFacebook : NSObject <NSCoding>

@property (nonatomic, strong) NSString *facebookPostId;
@property (nonatomic, strong) NSURL *facebookPostURL;
@property (nonatomic,strong) NSString *facebookPostBody;
@property (nonatomic, strong) NSURL *linkURL; // optional
@property (nonatomic, strong) NSDate *createdTime;
@property (nonatomic, strong) NSString *facebookPageName; // optional
@property (nonatomic, assign) NSUInteger teamId; // optional
@property (nonatomic, strong) JBTeam *limitedTeam; // optional
@property (nonatomic, strong) NSURL *authorPhotoURL;
@property (nonatomic, strong) NSURL *photoURL;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
