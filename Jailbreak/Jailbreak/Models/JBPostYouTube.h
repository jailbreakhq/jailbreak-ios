//
//  JBPostYouTube.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <Foundation/Foundation.h>

@interface JBPostYouTube : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *youTubeDescription;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSString *authorUsername;
@property (nonatomic, strong) NSURL *authorURL;
@property (nonatomic, assign) NSUInteger teamId; // optional
@property (nonatomic, strong) JBTeam *limitedTeam; // optional
@property (nonatomic, strong) NSDate *createdTime;
@property (nonatomic, strong) NSURL *authorPhotoURL;
@property (nonatomic, strong) NSURL *thumbnailURL;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
