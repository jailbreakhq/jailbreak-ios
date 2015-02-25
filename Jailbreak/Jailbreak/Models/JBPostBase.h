//
//  JBPostBase.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

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

@interface JBPostBase : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger postId;
@property (nonatomic, assign) JBPostType postType;

- (instancetype)initWithJSON:(NSDictionary *)json;
+ (JBPostType)getPostTypeFromString:(NSString *)string;

@end
