//
//  JBPost.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBCheckin.h"
#import "JBPostLink.h"
#import "JBPostVine.h"
#import "JBPostTwitter.h"
#import "JBPostFacebook.h"
#import "JBPostInstagram.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JBPostType)
{
    JBPostTypeUndefined = 0,
    JBPostTypeTwitter,
    JBPostTypeInstagram,
    JBPostTypeFacebook,
    JBPostTypeVine,
    JBPostTypeDonate,
    JBPostTypeLink,
    JBPostTypeCheckin,
};

@interface JBPost : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger postId;
@property (nonatomic, assign) JBPostType postType;
@property (nonatomic, assign) BOOL containsThumbnail;

// For convenice have weak references to these for quick access
@property (nonatomic, weak) JBTeam *limitedTeam;
@property (nonatomic, weak) NSDate *createdTime;

@property (nonatomic, strong) JBCheckin *checkin;
@property (nonatomic, strong) JBPostLink *link;
@property (nonatomic, strong) JBPostVine *vine;
@property (nonatomic, strong) JBPostTwitter *twitter;
@property (nonatomic, strong) JBPostFacebook *facebook;
@property (nonatomic, strong) JBPostInstagram *instagram;

- (instancetype)initWithJSON:(NSDictionary *)json;
+ (JBPostType)getPostTypeFromString:(NSString *)string;

@end
