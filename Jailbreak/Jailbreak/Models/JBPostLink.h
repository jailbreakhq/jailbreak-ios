//
//  JBPostLink.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 24/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBPostLink : NSObject <NSCoding>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *linkText;
@property (nonatomic, strong) NSString *linkDescription;
@property (nonatomic, strong) NSURL *photoURL; // optional

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
